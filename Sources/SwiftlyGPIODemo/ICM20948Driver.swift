import Foundation
import SwiftlyGPIO

let ICM20948Id = 0xEA
let MagAK00916i2cAddress = 0x0C
let MagAK00916Id = 0x4809

enum MagnetometerRegisters: Int {
  case whoAmI
}

enum ICM20498Error: Error {
  case paramError
  case invalidDeviceId
  case invalidSlaveId
}

enum ICM20498Registers: Int {
  case selectBank = 0x7F
}

enum ICM20498Register0Comamnds: Int {
  case whoAmI = 0x00
  case userControl = 0x03
  case powerManagement1 = 0x06
  case interruptPinConfig = 0x0F
}

enum ICM20498UserControlBits: Int {
  case i2cMasterReset = 0x1
  case SRAMReset
  case DMPReset
  case i2cSlaveReset
  case i2cMasterEnable
  case FIFOEnable
  case DMPEnable
}

struct SlavePeripheralRegisters {
  let address: ICM20498Register3Comamnds
  let register: ICM20498Register3Comamnds
  let control: ICM20498Register3Comamnds
  let dataOut: ICM20498Register3Comamnds
}

enum ICM20498Register3Comamnds: Int {
  case i2cMasterDatarateConfig
  case i2cMasterControl
  case i2cMasterDelayControl
  case i2cSlave0Address
  case i2cSlave0RegisterAddress
  case i2cSlave0Control
  case i2cSlave0DataOut
  case i2cSlave1Address
  case i2cSlave1RegisterAddress
  case i2cSlave1Control
  case i2cSlave1DataOut
  case i2cSlave2Address
  case i2cSlave2RegisterAddress
  case i2cSlave2Control
  case i2cSlave2DataOut
  case i2cSlave3Address
  case i2cSlave3RegisterAddress
  case i2cSlave3Control
  case i2cSlave3DataOut
  case i2cSlave4Address
  case i2cSlave4RegisterAddress
  case i2cSlave4Control
  case i2cSlave4DataOut
  case i2cSlave4DataInput
  case registerBankSelect = 0x7F

  static func slaveRegisters(deviceNumber: Int) throws -> SlavePeripheralRegisters {
    guard (0...4).contains(deviceNumber) else { 
      throw ICM20498Error.invalidSlaveId 
    }

    return SlavePeripheralRegisters(
      address: ICM20498Register3Comamnds(rawValue: ICM20498Register3Comamnds.i2cSlave0Address.rawValue + deviceNumber)!,
      register: ICM20498Register3Comamnds(rawValue: ICM20498Register3Comamnds.i2cSlave0RegisterAddress.rawValue + deviceNumber)!,
      control: ICM20498Register3Comamnds(rawValue: ICM20498Register3Comamnds.i2cSlave0Control.rawValue + deviceNumber)!,
      dataOut: ICM20498Register3Comamnds(rawValue: ICM20498Register3Comamnds.i2cSlave0DataOut.rawValue + deviceNumber)!
    )
  }
}

enum InterrupPinConfigBit: Int {
  case enableBypass = 1
}

enum i2cMasterControlBit: Int {
  case clock = 0x03
  case i2cMasterTransition = 0x04
  case enableMulitMaster = 0x07
}

enum i2cMasterTransation: Int {
  case restartBetweenReads
  case stopBetweenReads
}

enum ICM204898PowerManagementBit: Int {
  case clockSelect
  case disableTempSensor = 3
  case enableLowPower = 5
  case enableSleep
  case resetDevice
}

class ICM20948Driver: I2CDevice {
  private let bankRange: ClosedRange<UInt8> = (0 ... 3)
  private var lastBank: UInt8 = 4

  public func startup() throws {
    guard try whoAmI() == ICM20948Id else {
      throw ICM20498Error.invalidDeviceId
    }

    try softwareReset()

    usleep(50)

    try enableSleep(false)
    try enableLowPower(false)
  }

  func startMagnetometer() throws {
    try enableMasterI2CMasterPassthrough(true)
  }

  public func whoAmI() throws -> UInt8 {
    try setBank(0)
    return UInt8(readByteData(command: ICM20498Register0Comamnds.whoAmI.rawValue))
  }

  func softwareReset() throws {
    try setBank(0)

    try writeBit(
      command: ICM20498Register0Comamnds.powerManagement1.rawValue,
      bitNumber: ICM204898PowerManagementBit.resetDevice.rawValue,
      enabled: true
    )
  }

  func enableSleep(_: Bool) throws {
    try setBank(0)

    try writeBit(
      command: ICM20498Register0Comamnds.powerManagement1.rawValue,
      bitNumber: ICM204898PowerManagementBit.enableSleep.rawValue,
      enabled: false
    )
  }

  func enableLowPower(_ enable: Bool) throws {
    try setBank(0)

    try writeBit(
      command: ICM20498Register0Comamnds.powerManagement1.rawValue,
      bitNumber: ICM204898PowerManagementBit.enableLowPower.rawValue,
      enabled: enable
    )
  }

  func enableMasterI2CMasterPassthrough(_ enable: Bool) throws {
    try setBank(0)

    try writeBit(
      command: ICM20498Register0Comamnds.interruptPinConfig.rawValue,
      bitNumber: InterrupPinConfigBit.enableBypass.rawValue,
      enabled: enable
    )
  }

  func setMasterTransition(_ mode: i2cMasterTransation) throws {
    try setBank(3)

    try writeBit(
      command: ICM20498Register3Comamnds.i2cMasterControl.rawValue,
      bitNumber: i2cMasterControlBit.i2cMasterTransition.rawValue,
      enabled: mode == .stopBetweenReads
    )
  }

  func setClock(frequency: UInt8) throws {
    try setBank(3)
    try writeBits(
      command: ICM20498Register3Comamnds.i2cMasterControl.rawValue,
      bitNumber: i2cMasterControlBit.enableMulitMaster.rawValue,
      data: frequency, length: 4
    )
  }

  func enableI2CMaster(_ enable: Bool) throws {
    try setBank(0)

    try writeBit(
      command: ICM20498Register0Comamnds.userControl.rawValue,
      bitNumber: ICM20498UserControlBits.i2cMasterEnable.rawValue,
      enabled: enable
    )
  }

  private func setBank(_ bank: UInt8) throws {
    guard bankRange.contains(bank) else {
      throw ICM20498Error.paramError
    }

    guard bank != lastBank else {
      return
    }

    try writeByteData(command: ICM20498Registers.selectBank.rawValue, data: bank)

    lastBank = bank
  }

  func configure(peripheral: Int, address _: UInt8, register _: UInt8, length _: UInt8, isReadWrite _: Bool, enable _: Bool, dataOnly _: Bool, swap _: Bool, dataOut _: UInt8) throws {
    let peripheralRegisters = try ICM20498Register3Comamnds.slaveRegisters(deviceNumber: peripheral)

    try setBank(3)



  }
}
