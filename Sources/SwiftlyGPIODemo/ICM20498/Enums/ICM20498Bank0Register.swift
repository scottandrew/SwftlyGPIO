enum ICM20498Bank0Register: UInt8, RegisterProtocol {
  case whoAmI = 0x00
  case userControl = 0x03
  case lpConfig = 0x05
  case powerManagement1 = 0x06
  case interruptPinConfig = 0x0F
  case i2cMasterStatus = 0x17
  case intStastus1 = 0x1A
  case accelXOutHigh = 0x2d
  case accelXOutLow
  case accelYOutHigh
  case accelYOutLow
  case accelZOutHigh
  case accelZOutLow
  case gyroXOutHigh
  case gyroXOutLow
  case gyroYOutHigh
  case gyroYOutLow
  case gyroZOutHigh
  case gyroZOutLow
  case tempOutHigh
  case tempOutLow
}
