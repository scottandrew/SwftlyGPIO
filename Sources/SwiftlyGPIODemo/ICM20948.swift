import Foundation

class ICM20948 {
  private let mpu = ICM20948Driver()

  func startup(deviceNumber: Int, address: Int32) throws {
    try mpu.open(deviceNumber: deviceNumber, address: address)

    guard try mpu.whoAmI() == ICM20948Id else {
      throw ICM20498Error.invalidDeviceId
    }

    try mpu.softwareReset()

    usleep(500)

    try mpu.enableSleep(false)
    try mpu.enableLowPower(false)
    try mpu.enableMasterI2CMasterPassthrough(false)
    try mpu.enableMaster(enable: true)

    // try mpu.masterReset();
    try mpu.resetMag()
    let whoAmiMag = try mpu.magnetometerWhoAmI()
   
    print("yo")
  }

  private func enableI2CMaster(_ enable: Bool) throws {
    try mpu.enableMasterI2CMasterPassthrough(false)
    try mpu.setMasterTransition(.stop)
    try mpu.setClock(frequency: 0x07)
    try mpu.enableI2CMaster(enable)
  }
}
