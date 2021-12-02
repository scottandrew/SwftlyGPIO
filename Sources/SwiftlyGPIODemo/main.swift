import Foundation
import SwiftlyGPIO

let icm20948 = ICM20948()
let keepLooping = true

do {
  try icm20948.startup(deviceNumber: 1, address: 0x69)
  
  print("startup done")
  
  while keepLooping {
    if try icm20948.isDataReady() {
      print("data ready")
      usleep(30)
    } else {
      print("data no ready")
      usleep(500)
    }
  }
  
} catch {
  print(error)
}
