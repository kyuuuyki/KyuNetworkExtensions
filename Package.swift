// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KyuNetworkExtensions",
	platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "KyuNetworkExtensions",
            targets: [
				"KyuNetworkExtensions",
			]
		),
    ],
    dependencies: [
		.package(
			name: "KyuGenericExtensions",
			url: "https://github.com/kyuuuyki/KyuGenericExtensions.git",
			branch: "main"
		),
		.package(
			name: "Moya",
			url: "https://github.com/Moya/Moya.git",
			from: "15.0.0"
		),
    ],
    targets: [
        .target(
            name: "KyuNetworkExtensions",
            dependencies: [
				"KyuGenericExtensions",
				"Moya",
			]
		),
        .testTarget(
            name: "KyuNetworkExtensionsTests",
            dependencies: [
				"KyuNetworkExtensions",
			]
		),
    ]
)
