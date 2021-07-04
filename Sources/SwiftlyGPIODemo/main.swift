import Foundation
import SwiftlyGPIO

let icm20948 = ICM20948()

do { 
  try icm20948.startup(deviceNumber: 1, address: 0x69)

} catch { 
  print (error)
}


