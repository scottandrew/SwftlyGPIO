import Foundation

extension ICM20948Driver {
  func readMagnetometer(register: MagnetometerRegister) throws -> UInt8 {
    let data = try i2cControllerPeripherial4TransactionRead(
      address: Magnetometeri2cAddress,
      register: register.rawValue,
      size: 1,
      sendRegisterAddress: true
    )

    return data[0]
  }

  func writeMagnetometer(register: MagnetometerRegister, data: BitStruct) throws {
    try writeMagnetometer(register: register, data: data.value)
  }

  func writeMagnetometer(register _: MagnetometerRegister, data: UInt8) throws {
    let dataToSend = Data([data])

    try i2cControllerPeripherial4TransactionWrite(
      address: Magnetometeri2cAddress,
      register: MagnetometerRegister.control3.rawValue,
      data: dataToSend,
      sendRegisterAddress: true
    )
  }

  func magnetometerWhoAmI() throws -> Int {
    let whoAmI1 = try readMagnetometer(register: .whoAmI1)
    let whoAmI2 = try readMagnetometer(register: .whoAmI2)

    let id = (Int(whoAmI1) << 8) | Int(whoAmI2)

    return id
  }

  func resetMag() throws {
    try writeMagnetometer(register: MagnetometerRegister.control3, data: 1)
  }

  func magnetometerSetMode(
    mode: AK09916Control2.Mode = .continuous,
    sampleRate: AK09916Control2.SampleRate
  ) throws {
    let control2 = AK09916Control2(mode: mode, sampleRate: sampleRate)

    try writeMagnetometer(register: .control2, data: control2)
  }

  func magnetometerConfigureRead() throws { 
    try i2cPeripheralConfigureForReading(
      peripheral: 0, 
      address: Magnetometeri2cAddress, 
      register: MagnetometerRegister.status1.rawValue, 
      readLength: 9, 
      dataOnly: false, 
      groupBehavior: .oddNumberEndsGroup, swap: false
    )
  }
}
