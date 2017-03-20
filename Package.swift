import PackageDescription

let package = Package(
	name: "IProto",
	targets: [
		Target(name: "CIProto"),
		Target(name: "IProto", dependencies: [.Target(name: "CIProto")]),
	],
	dependencies: [
		.Package(url: "https://github.com/my-mail-ru/swift-BinaryEncoding.git", versions: Version(0, 2, 0)..<Version(0, .max, .max)),
	]
)
