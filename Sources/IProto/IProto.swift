import CIProto

public func exchange(message: Message, timeout: Double? = nil) {
	withExtendedLifetime(message) {
		if var tv = timeout.map({ timeval($0) }) {
			iproto_do(message.pointer, &tv)
		} else {
			iproto_do(message.pointer, nil)
		}
	}
}

public func exchange(messages: [Message], timeout: Double? = nil) {
	withExtendedLifetime(messages) {
		var pointers: [OpaquePointer?] = messages.map { $0.pointer }
		if var tv = timeout.map({ timeval($0) }) {
			iproto_bulk(&pointers, Int32(pointers.count), &tv)
		} else {
			iproto_bulk(&pointers, Int32(pointers.count), nil)
		}
	}
}

public enum IProtoLog {
	public static var level: Level = .info {
		didSet { iproto_set_logmask(iproto_logmask_t(rawValue: level.rawValue | mask.rawValue)) }
	}

	public static var mask: Mask = [] {
		didSet { iproto_set_logmask(iproto_logmask_t(rawValue: level.rawValue | mask.rawValue)) }
	}

	public static var callback: ((Level, String) -> Void)? {
		didSet { iproto_set_logfunc(callback != nil ? logfuncWrapper : nil) }
	}

	public enum Level : RawRepresentable, Equatable {
		case nothing
		case error
		case warning
		case info
		case debug

		public init?(rawValue: Int32) {
			switch rawValue {
				case LOG_NOTHING.rawValue: self = .nothing
				case LOG_ERROR.rawValue: self = .error
				case LOG_WARNING.rawValue: self = .warning
				case LOG_INFO.rawValue: self = .info
				case LOG_DEBUG.rawValue: self = .debug
				default: return nil
			}
		}

		public var rawValue: Int32 {
			switch self {
				case .nothing: return LOG_NOTHING.rawValue
				case .error: return LOG_ERROR.rawValue
				case .warning: return LOG_WARNING.rawValue
				case .info: return LOG_INFO.rawValue
				case .debug: return LOG_DEBUG.rawValue
			}
		}
	}

	public struct Mask : OptionSet {
		public var rawValue: Int32

		public init(rawValue: Int32) {
			self.rawValue = rawValue
		}

		public static let data = Mask(rawValue: LOG_DATA.rawValue)
		public static let connect = Mask(rawValue: LOG_CONNECT.rawValue)
		public static let io = Mask(rawValue: LOG_IO.rawValue)
		public static let ev = Mask(rawValue: LOG_EV.rawValue)
		public static let time = Mask(rawValue: LOG_TIME.rawValue)
		public static let retry = Mask(rawValue: LOG_RETRY.rawValue)
		public static let fork = Mask(rawValue: LOG_FORK.rawValue)
		public static let stat = Mask(rawValue: LOG_STAT.rawValue)
		public static let graphite = Mask(rawValue: LOG_GRAPHITE.rawValue)
	}
}

private func logfuncWrapper(mask: iproto_logmask_t, message: UnsafePointer<Int8>?) {
	let level = IProtoLog.Level(rawValue: mask.rawValue & LOG_LEVEL.rawValue)!
	IProtoLog.callback?(level, String(cString: message!))
}
