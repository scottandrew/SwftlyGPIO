enum MagnetometerRegister: UInt8, RegisterProtocol { 
  case whoAmI1
  case whoAmI2
  case reserved1
  // Secret sauce according to SpartkFun. DMP reading starts here.
  case reserved2
  case status1 = 0x10
  case xAxisLow
  case xAxisHigh
  case yAxisLow
  case yAxisHigh
  case zAxisLow
  case zAxisHigh
  case status2 = 0x18
  case control2 = 0x31
  case control3
}