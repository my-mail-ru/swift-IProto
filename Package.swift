import PackageDescription

let package = Package(
	name: "IProto",
	targets: [
		Target(name: "CIProto"),
		Target(name: "IProto", dependencies: [.Target(name: "CIProto")]),
	],
	dependencies: [
		.Package(url: "https://github.com/my-mail-ru/swift-BinaryEncoding.git", majorVersion: 0),
	]
)
