import Foundation

extension ICM20948Driver { 
  func readMagnetometer(register: MagnetometerRegister) throws -> UInt8 { 
    let data = try i2cControllerPeripherial4TransactionRead(
      address: Magnetometeri2cAddress, 
      register: register.rawValue,
      size: 1, 
      sendRegisterAddress: true)
  
    return data[0]
  }

  func magnetometerWhoAmI() throws -> Int { 
    let whoAmI1 = try readMagnetometer(register: .whoAmI1)
    let whoAmI2 = try readMagnetometer(register: .whoAmI2)

    let id = (Int(whoAmI1) << 8) | Int(whoAmI2)

    return id;
  }

  func resetMag() throws { 
          var data = Data(count: 1)

    data[0] = 1

    try i2cControllerPeripherial4TransactionWrite(
      address: Magnetometeri2cAddress,
      register: MagnetometerRegister.control3.rawValue,
      data: data,
      sendRegisterAddress: true
    )
  }
}