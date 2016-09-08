import CIProto
import BinaryEncoding

public final class Message {
	let pointer: OpaquePointer
	public let cluster: Cluster
	public let code: Int32
	public let request: BinaryEncodedData
	var softRetryCallback: ((Message) -> Bool)? = nil

	public init(cluster: Cluster, code: Int32, data: BinaryEncodedData) {
		self.cluster = cluster // Lifetime
		self.code = code // For debug purposes
		request = data // Ensure what data is alive long enough
		pointer = request.withUnsafeBufferRawPointer {
			iproto_message_init(code, UnsafeMutablePointer(mutating: $0.baseAddress?.assumingMemoryBound(to: UnsafePointer<OpaquePointer>.self)), $0.count)
		}
		iproto_message_set_cluster(pointer, cluster.pointer)
		iproto_message_options(pointer)!.pointee.data = Unmanaged<Message>.passUnretained(self).toOpaque()
	}

	deinit {
		iproto_message_free(pointer)
	}

	public var error: IProtoError {
		return IProtoError(rawValue: iproto_message_error(pointer).rawValue)
	}

	public var response: Response {
		return Response(of: self)
	}

	public enum Response {
		case ok(Ok)
		case error(IProtoError)

		init(of message: Message) {
			let error = message.error
			self = error == .ok ? .ok(Ok(of: message)) : .error(error)
		}

		public enum From {
			case master
			case replica
		}

		public struct Ok {
			let message: Message
			public var from: From
			let buffer: UnsafeBufferRawPointer

			init(of message: Message) {
				self.message = message
				(from, buffer) = withExtendedLifetime(message) {
					var size = 0
					var replica = false
					let addr = iproto_message_response(message.pointer, &size, &replica)
					return (
						from: replica ? .replica : .master,
						buffer: UnsafeBufferRawPointer(start: addr, count: size)
					)
				}
			}

			public var data: BinaryEncodedData {
				return withExtendedLifetime(message) {
					return BinaryEncodedData(copyFrom: buffer.baseAddress!, count: buffer.count)
				}
			}

			public func withUnsafeBufferRawPointer<R>(_ body: (UnsafeBufferRawPointer) throws -> R) rethrows -> R {
				return try withExtendedLifetime(message) {
					return try body(buffer)
				}
			}
		}
	}
}

extension Message : CustomDebugStringConvertible {
	public var debugDescription: String {
		return "Message(code: \(code), request: \(request), response: \(response))"
	}
}

extension Message.Response : CustomDebugStringConvertible {
	public var debugDescription: String {
		switch self {
			case .ok(let response):
				return "ok(from: \(response.from), data: \(response.data))"
			case .error(let error):
				return "error(\(error))"
		}
	}
}
