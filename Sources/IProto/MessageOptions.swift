import CIProto

extension Message {
	public var options: Options { return Options(of: self) }

	public final class Options {
		let message: Message
		let pointer: UnsafeMutablePointer<iproto_message_opts_t>

		init(of message: Message) {
			self.message = message
			self.pointer = iproto_message_options(message.pointer)
		}

		public var shard: Int {
			get { return Int(pointer.pointee.shard_num) }
			set { pointer.pointee.shard_num = UInt32(newValue) }
		}

		public enum From {
			case master
			case replica
			case masterThenReplica
			case replicaThenMaster

			init(rawValue: iproto_from_t) {
				switch rawValue {
					case FROM_MASTER: self = .master
					case FROM_REPLICA: self = .replica
					case FROM_MASTER_REPLICA: self = .masterThenReplica
					case FROM_REPLICA_MASTER: self = .replicaThenMaster
					default: preconditionFailure("Unknown iproto_from_t value: \(rawValue)")
				}
			}

			var rawValue: iproto_from_t {
				switch self {
					case .master: return FROM_MASTER
					case .replica: return FROM_REPLICA
					case .masterThenReplica: return FROM_MASTER_REPLICA
					case .replicaThenMaster: return FROM_REPLICA_MASTER
				}
			}
		}

		public var from: From {
			get { return From(rawValue: pointer.pointee.from) }
			set { pointer.pointee.from = newValue.rawValue }
		}

		public struct Retry : OptionSet {
			public var rawValue: UInt32

			public init(rawValue: UInt32) {
				self.rawValue = rawValue
			}

			public static let early = Retry(rawValue: RETRY_EARLY.rawValue)
			public static let safe  = Retry(rawValue: RETRY_SAFE.rawValue)
			public static let same  = Retry(rawValue: RETRY_SAME.rawValue)
		}

		public var retry: Retry {
			get { return Retry(rawValue: pointer.pointee.retry.rawValue) }
			set { pointer.pointee.retry.rawValue = newValue.rawValue }
		}

		public var maxTries: Int {
			get { return Int(pointer.pointee.max_tries) }
			set { pointer.pointee.max_tries = Int32(newValue) }
		}

		public var timeout: Double {
			get { return Double(pointer.pointee.timeout) }
			set { pointer.pointee.timeout = timeval(newValue) }
		}

		public var earlyTimeout: Double {
			get { return Double(pointer.pointee.early_timeout) }
			set { pointer.pointee.early_timeout = timeval(newValue) }
		}

		public var softRetryDelay: (min: Double, max: Double) {
			get { return (min: Double(pointer.pointee.soft_retry_delay_min), max: Double(pointer.pointee.soft_retry_delay_max)) }
			set {
				pointer.pointee.soft_retry_delay_min = timeval(newValue.min)
				pointer.pointee.soft_retry_delay_max = timeval(newValue.max)
			}
		}

		public var softRetryCallback: ((Message) -> Bool)? {
			get { return message.softRetryCallback }
			set {
				message.softRetryCallback = newValue
				pointer.pointee.soft_retry_callback = newValue == nil ? nil : {
					let data = iproto_message_options($0).pointee.data!
					let message = Unmanaged<Message>.fromOpaque(data).takeUnretainedValue()
					return message.options.softRetryCallback!(message)
				}
			}
		}
	}
}
