// swift-tools-version:4.0
import PackageDescription

let package = Package(
	name: "IProto",
	products: [
		.library(name: "IProto", targets: ["IProto"]),
	],
	dependencies: [
		.package(url: "https://github.com/my-mail-ru/swift-CIProto.git", from: "0.2.1"),
		.package(url: "https://github.com/my-mail-ru/swift-BinaryEncoding.git", from: "0.2.1"),
	],
	targets: [
		.target(name: "IProto", dependencies: ["BinaryEncoding"]),
		.testTarget(name: "IProtoTests", dependencies: ["IProto"]),
	]
)
