import PackageDescription

let package = Package(
	name: "IProto",
	targets: [
		Target(name: "IProto"),
	],
	dependencies: [
		.Package(url: "https://github.com/my-mail-ru/swift-CIProto.git", versions: Version(0, 1, 0)..<Version(0, .max, .max)),
		.Package(url: "https://github.com/my-mail-ru/swift-BinaryEncoding.git", versions: Version(0, 2, 0)..<Version(0, .max, .max)),
	]
)
