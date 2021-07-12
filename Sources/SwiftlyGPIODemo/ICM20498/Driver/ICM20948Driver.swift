import Foundation
import SwiftlyGPIO

let ICM20948Id = 0xEA
let MagAK00916i2cAddress = 0x0C
let MagAK00916Id = 0x4809

class ICM20948Driver: I2CDevice {
  private let bankRange: ClosedRange<UInt8> = (0 ... 3)
  private var lastBank: UInt8 = 4

  private func setBank(_ bank: UInt8) throws {
    guard bankRange.contains(bank) else {
      throw ICM20498Error.paramError
    }

    guard bank != lastBank else {
      return
    }

    let bankData = Bank()
    bankData.userBank = bank;

    try write(command: ICM20498Register.selectBank, data: bankData.value)

    lastBank = bank
  }

  public func whoAmI() throws -> UInt8 {
    return UInt8(try read(bank: 0, command: ICM20498Bank0Register.whoAmI))
  }

  func softwareReset() throws {
    let powerManagement: PowerManagement1 = try read(
      bank: 0, command:
      ICM20498Bank0Register.powerManagement1
    )

    powerManagement.resetDevice = true

    try write(bank: 0, command: ICM20498Bank0Register.powerManagement1, data: powerManagement)
  }

  func enableSleep(_ enable: Bool) throws {
    let powerManagement: PowerManagement1 = try read(
      bank: 0, command:
      ICM20498Bank0Register.powerManagement1
    )

    powerManagement.sleep = enable

    try write(bank: 0, command: ICM20498Bank0Register.powerManagement1, data: powerManagement)
  }

  func enableLowPower(_ enable: Bool) throws {
    let powerManagement: PowerManagement1 = try read(
      bank: 0, command:
      ICM20498Bank0Register.powerManagement1
    )

    powerManagement.enableLowPower = enable

    try write(bank: 0, command: ICM20498Bank0Register.powerManagement1, data: powerManagement)
  }

  func enableMasterI2CMasterPassthrough(_ enable: Bool) throws {
    let interruptConfig: InterruptPinConfiguration = try read(bank: 0, command: ICM20498Bank0Register.interruptPinConfig)

    interruptConfig.isBypassEnabled = enable

    try write(bank: 0, command: ICM20498Bank0Register.interruptPinConfig, data: interruptConfig)
  }

  func setMasterTransition(_ mode: i2cMasterControl.PeripheralTranstion) throws {
    let control: i2cMasterControl = try read(bank: 3, command: ICM20498Bank3Register.i2cMasterControl)

    control.peripheralTransition = mode

    try write(bank: 3, command: ICM20498Bank3Register.i2cMasterControl, data: control)
  }

  func setClock(frequency: UInt8) throws {
    let control: i2cMasterControl = try read(bank: 3, command: ICM20498Bank3Register.i2cMasterControl)

    control.clockFrequency = frequency

    try write(bank: 3, command: ICM20498Bank3Register.i2cMasterControl, data: control)
  }

  func enableI2CMaster(_ enable: Bool) throws {
    let control: UserControl = try read(bank: 0, command: ICM20498Bank0Register.userControl)

    control.isI2CMasterEnabled = enable

    try write(bank: 0, command: ICM20498Bank0Register.userControl, data: control)
  }

  func masterReset() throws { 
    let control: UserControl = try read(bank: 0, command: ICM20498Bank0Register.userControl)

    control.resetI2CMaster()

    try write(bank: 0, command: ICM20498Bank0Register.userControl, data: control)
  }

  func setSampleMode(
    i2cMasterMode: SampleModeRegister.Mode? = nil, 
    accelerometerMode: SampleModeRegister.Mode? = nil, 
    gyroscopeMode: SampleModeRegister.Mode? = nil
  ) throws { 
    let sampleModes: SampleModeRegister = try read(bank: 0, command: ICM20498Bank0Register.lpConfig)

    if let i2cMasterMode = i2cMasterMode  { 
      sampleModes.i2cMasterMode = i2cMasterMode
    }

    if let accelerometerMode = accelerometerMode { 
      sampleModes.accelerometerMode = accelerometerMode
    }

    if let gyroscopeMode = gyroscopeMode { 
      sampleModes.gyroscopeMode = gyroscopeMode
    }

    try write(bank: 0, command: ICM20498Bank0Register.lpConfig, data: sampleModes)
  }

  @discardableResult
  func write<U>(command: U, data: UInt8) throws -> Int where U: RegisterProtocol {
    return try writeByteData(command: Int(command.register), data: data)
  }

  @discardableResult
  func write<U>(bank: UInt8, command: U, data: BitStruct) throws -> Int where U: RegisterProtocol {
    try setBank(bank)
    return try writeByteData(command: Int(command.register), data: data.value)
  }

  @discardableResult
  func write<U>(bank: UInt8, command: U, data: UInt8) throws -> Int where U: RegisterProtocol {
    try setBank(bank)
    return try writeByteData(command: Int(command.register), data: data)
  }

  func read<T, U>(bank: UInt8, command: U) throws -> T where T: BitStruct, U: RegisterProtocol {
    try setBank(bank)
    let data = readByteData(command: Int(command.register))

    return T(value: data)
  }

  func read<U>(bank: UInt8, command: U) throws -> UInt8 where U: RegisterProtocol {
    try setBank(bank)

    return readByteData(command: Int(command.register))
  }
}
