// swift-tools-version:5.4
import PackageDescription

let package = Package(
  name: "SwiftlyGPIO",
  products: [ 
    .executable(name: "SwiftlyGPIODemo", targets:["SwiftlyGPIODemo"]),
    .library(name: "SwiftlyGPIO", targets:["SwiftlyGPIO"])
  ],
  dependencies: [],
  targets: [
    .systemLibrary(
      name: "libgpiod",
      pkgConfig: "libgpiod"
    ),
    .systemLibrary(
      name: "libi2c",
      pkgConfig: "libi2c"
    ),
    .target(name: "SwiftlyGPIO",
      dependencies: ["libgpiod", "libi2c"]
    ),
    .executableTarget(
      name: "SwiftlyGPIODemo",
      dependencies: ["SwiftlyGPIO"]
    )
  ]
)