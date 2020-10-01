// swift-tools-version:5.1
import PackageDescription

let package = Package(name: "SwiftChess",
                      platforms: [.macOS(.v10_14),
                                  .iOS(.v10),
                                  .tvOS(.v10)],
                      products: [.library(name: "SwiftChess",
                                          targets: ["SwiftChess"])],
                      targets: [.target(name: "SwiftChess",
                                        path: "SwiftChess/Source"),
                                .testTarget(name: "SwiftChessTests",
                                            dependencies: ["SwiftChess"],
                                            path: "SwiftChess/SwiftChessTests")],
                      swiftLanguageVersions: [.v5])
