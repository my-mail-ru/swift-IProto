import CIProto

private let initializeOnce: Void = { iproto_initialize() }()

public final class Cluster {
	let pointer: OpaquePointer

	public init(shards: [Shard]) {
		initializeOnce
		pointer = iproto_cluster_init()
		for shard in shards {
			add(shard: shard)
		}
	}

	deinit {
		iproto_cluster_free(pointer)
	}

	func add(shard: Shard) {
		iproto_cluster_add_shard(pointer, shard.passOwnership())
	}
}

public final class Shard {
	private let pointer: OpaquePointer
	private var owned = true

	public init(masters: [Server], replicas: [Server] = []) {
		initializeOnce
		pointer = iproto_shard_init()
		var masterPointers: [OpaquePointer?] = masters.map { $0.pointer }
		iproto_shard_add_servers(pointer, false, &masterPointers, Int32(masterPointers.count))
		if !replicas.isEmpty {
			var replicaPointers: [OpaquePointer?] = replicas.map { $0.pointer }
			iproto_shard_add_servers(pointer, false, &replicaPointers, Int32(replicaPointers.count))
		}
	}

	deinit {
		if owned {
			iproto_shard_free(pointer)
		}
	}

	func passOwnership() -> OpaquePointer {
		precondition(owned, "Ownership violation")
		owned = false
		return pointer
	}
}

public final class Server {
	let pointer: OpaquePointer

	public init(host: String, port: Int) {
		initializeOnce
		pointer = host.withCString {
			iproto_server_init(UnsafeMutablePointer(mutating: $0), Int32(port))
		}
	}

	deinit {
		iproto_server_free(pointer)
	}
}
