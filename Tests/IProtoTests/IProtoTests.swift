import XCTest
import IProto
import BinaryEncoding

class IProtoTests: XCTestCase {
	static var allTests : [(String, (IProtoTests) -> () throws -> Void)] {
		return [
			("testBasic", testBasic),
		]
	}

	func testBasic() {
		IProtoLog.level = .debug
		IProtoLog.callback = { print("Swift: IProto: \($0): \($1)") }
		defer {
			IProtoLog.level = .info
			IProtoLog.callback = nil
		}
		let cluster = Cluster(shards: [ Shard(masters: [ Server(host: "127.0.0.1", port: 9987) ]) ])
		let message = Message(cluster: cluster, code: 17, data: BinaryEncodedData())
		exchange(message: message)
		XCTAssertEqual(message.error, .connectErr)
	}
}
