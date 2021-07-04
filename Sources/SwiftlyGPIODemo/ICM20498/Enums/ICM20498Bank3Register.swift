enum ICM20498Bank3Register: UInt8, RegisterProtocol {
  case i2cMasterDataRateConfig
  case i2cMasterControl
  case i2cMasterDelayControl
  case i2cPeripheral0Address
  case i2cPeripheral0Register
  case i2cPeripheral0Control
  case i2cPeripheral0DataOut
  case i2cPeripheral1Address
  case i2cPeripheral1Register
  case i2cPeripheral1Control
  case i2cPeripheral1DataOut
  case i2cPeripheral2Address
  case i2cPeripheral2Register
  case i2cPeripheral2Control
  case i2cPeripheral2DataOut
  case i2cPeripheral3Address
  case i2cPeripheral3Register
  case i2cPeripheral3Control
  case i2cPeripheral3DataOut
  case i2cPeripheral4Address
  case i2cPeripheral4Register
  case i2cPeripheral4Control
  case i2cPeripheral4DataOut
  case i2cPeripheral4DataInput
  case registerBankSelect = 0x7F

  static func PeripheralRegisters(deviceNumber: UInt8) throws -> SecondaryPeripheralRegisters {
    guard (0...4).contains(deviceNumber) else { 
      throw ICM20498Error.invalidPeripheralId 
    }

    return SecondaryPeripheralRegisters(
      address: ICM20498Bank3Register(rawValue: ICM20498Bank3Register.i2cPeripheral0Address.rawValue + deviceNumber)!,
      register: ICM20498Bank3Register(rawValue: ICM20498Bank3Register.i2cPeripheral0Register.rawValue + deviceNumber)!,
      control: ICM20498Bank3Register(rawValue: ICM20498Bank3Register.i2cPeripheral0Control.rawValue + deviceNumber)!,
      dataOut: ICM20498Bank3Register(rawValue: ICM20498Bank3Register.i2cPeripheral0DataOut.rawValue + deviceNumber)!
    )
  }
}