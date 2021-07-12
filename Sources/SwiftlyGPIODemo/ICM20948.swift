import Foundation

class ICM20948 {
  private let mpu = ICM20948Driver()
  private let maxMagnometerTries = 10

  func startup(deviceNumber: Int, address: Int32) throws {
    try mpu.open(deviceNumber: deviceNumber, address: address)

    guard try mpu.whoAmI() == ICM20948Id else {
      throw ICM20498Error.invalidDeviceId
    }

    try mpu.softwareReset()

    usleep(5000)

    try mpu.enableSleep(false)
    try mpu.enableLowPower(false)
    try mpu.enableMasterI2CMasterPassthrough(false)

    try startMagnometer()

    try mpu.setSampleMode(accelerometerMode: .continuous, gyroscopeMode: .continuous)
  }

  private func startMagnometer() throws {
    try mpu.enableMaster(enable: true)
    try mpu.resetMag()
    var attempts = 0
    // According to spark fun samples the Magsenso might
    // stop responding for some time over i2c so we
    // will keep tring to get the id. If we fail we will
    // reset the master interface and try again.
    while attempts < maxMagnometerTries {
      if let magnetometerId = try? mpu.magnetometerWhoAmI(), magnetometerId == MagnetometerWhoAmI {
        break
      }

      try mpu.masterReset()
      usleep(100)
      attempts += 1
    }

    if attempts >= maxMagnometerTries {
      throw ICM20498Error.invalidMagnetometerId
    }

    try mpu.magnetometerSetMode(sampleRate: .rate100hz)
    try mpu.magnetometerConfigureRead()
  }
}
