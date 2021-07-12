enum ICM20498Bank0Register: UInt8, RegisterProtocol {
  case whoAmI = 0x00
  case userControl = 0x03
  case lpConfig = 0x05
  case powerManagement1 = 0x06
  case interruptPinConfig = 0x0F
  case i2cMasterStatus = 0x17
}
