import CIProto

public enum IProtoError : Error, RawRepresentable, Equatable {
	case ok
	case timeout
	case clusterNotSet
	case invalidShardNum
	case loseEarlyRetry
	case noServerAvailable
	case hostUnknown
	case connectErr
	case protoErr
	case nothingToDo
	case alreadyConnected
	case connectInProgress
	case requestInProgress
	case requestInSend
	case requestInRecv
	case requestReady
	case connectNonBlock
	case operationTimeout

	case unknown(UInt32)

	public init(rawValue: UInt32) {
		switch iproto_error_t(rawValue: rawValue) {
			case ERR_CODE_OK: self = .ok
			case ERR_CODE_TIMEOUT: self = .timeout
			case ERR_CODE_CLUSTER_NOT_SET: self = .clusterNotSet
			case ERR_CODE_INVALID_SHARD_NUM: self = .invalidShardNum
			case ERR_CODE_LOSE_EARLY_RETRY: self = .loseEarlyRetry
			case ERR_CODE_NO_SERVER_AVAILABLE: self = .noServerAvailable
			case ERR_CODE_HOST_UNKNOWN: self = .hostUnknown
			case ERR_CODE_CONNECT_ERR: self = .connectErr
			case ERR_CODE_PROTO_ERR: self = .protoErr
			case ERR_CODE_NOTHING_TO_DO: self = .nothingToDo
			case ERR_CODE_ALREADY_CONNECTED: self = .alreadyConnected
			case ERR_CODE_CONNECT_IN_PROGRESS: self = .connectInProgress
			case ERR_CODE_REQUEST_IN_PROGRESS: self = .requestInProgress
			case ERR_CODE_REQUEST_IN_SEND: self = .requestInSend
			case ERR_CODE_REQUEST_IN_RECV: self = .requestInRecv
			case ERR_CODE_REQUEST_READY: self = .requestReady
			case ERR_CODE_CONNECT_NON_BLOCK: self = .connectNonBlock
			case ERR_CODE_OPERATION_TIMEOUT: self = .operationTimeout
			default: self = .unknown(rawValue)
		}
	}

	public var rawValue: UInt32 {
		let error: iproto_error_t
		switch self {
			case .ok: error = ERR_CODE_OK
			case .timeout: error = ERR_CODE_TIMEOUT
			case .clusterNotSet: error = ERR_CODE_CLUSTER_NOT_SET
			case .invalidShardNum: error = ERR_CODE_INVALID_SHARD_NUM
			case .loseEarlyRetry: error = ERR_CODE_LOSE_EARLY_RETRY
			case .noServerAvailable: error = ERR_CODE_NO_SERVER_AVAILABLE
			case .hostUnknown: error = ERR_CODE_HOST_UNKNOWN
			case .connectErr: error = ERR_CODE_CONNECT_ERR
			case .protoErr: error = ERR_CODE_PROTO_ERR
			case .nothingToDo: error = ERR_CODE_NOTHING_TO_DO
			case .alreadyConnected: error = ERR_CODE_ALREADY_CONNECTED
			case .connectInProgress: error = ERR_CODE_CONNECT_IN_PROGRESS
			case .requestInProgress: error = ERR_CODE_REQUEST_IN_PROGRESS
			case .requestInSend: error = ERR_CODE_REQUEST_IN_SEND
			case .requestInRecv: error = ERR_CODE_REQUEST_IN_RECV
			case .requestReady: error = ERR_CODE_REQUEST_READY
			case .connectNonBlock: error = ERR_CODE_CONNECT_NON_BLOCK
			case .operationTimeout: error = ERR_CODE_OPERATION_TIMEOUT
			case .unknown(let rawValue): error = iproto_error_t(rawValue: rawValue)
		}
		return error.rawValue
	}
}

extension IProtoError : CustomStringConvertible, CustomDebugStringConvertible {
	public var description: String {
		return String(cString: errcode_desc(rawValue))
	}

	public var debugDescription: String {
		return "IProtoError(0x\(String(rawValue, radix: 16)): \(description))"
	}
}
