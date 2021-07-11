import Foundation

extension ICM20948Driver {
  internal func pollForPeripheral4Completion() throws {
    let maxTries = 1000
    var count = 0
    var status = i2cMasterStatus(value: 5)

    while count < maxTries {
      // we need to keep reading the status register to see when it
      // tells us it is done.
      status = try read(bank: 0, command: ICM20498Bank0Register.i2cMasterStatus)

      if status.isPeripheral4Done {
        break
      }

      print("\(status.value)")
      count += 1
    }

    if count >= maxTries {
      throw ICM20498Error.peripheral4TransactionFailed
    }
  }

  func i2cControllerPeripherial4TransactionWrite(
    address: UInt8,
    register: UInt8,
    data: Data,
    sendRegisterAddress: Bool
  ) throws {
    let addressData = PeripheralAddressRegister(address: address,
                                                mode: .write)

    try write(bank: 3, command: ICM20498Bank3Register.i2cPeripheral4Address, data: addressData)
    try write(bank: 3, command: ICM20498Bank3Register.i2cPeripheral4Register, data: register)

    let controlRegister = Peripheral4ControlRegister(isEnabled: true,
                                                    isInterruptEnabled: false,
                                                    registerDis: !sendRegisterAddress,
                                                    delay: 0)

    // Keep pusing data..
    for byte in data {
      try write(
        bank: 3,
        command: ICM20498Bank3Register.i2cPeripheral4DataOut,
        data: byte
      )

      // We need to kick off the transaction
      try write(
        bank: 3,
        command: ICM20498Bank3Register.i2cPeripheral4Control,
        data: controlRegister
      )

      try pollForPeripheral4Completion()
    }
  }

  func i2cControllerPeripherial4TransactionRead(
    address: UInt8,
    register: UInt8,
    size: Int,
    sendRegisterAddress: Bool
  ) throws -> Data {
    let addressData = PeripheralAddressRegister(address: address)
    var readData = Data(count: size)

    try write(bank: 3, command: ICM20498Bank3Register.i2cPeripheral4Address, data: addressData)
    try write(bank: 3, command: ICM20498Bank3Register.i2cPeripheral4Register, data: register)

    let controlRegister = Peripheral4ControlRegister(
      isEnabled: true,
      isInterruptEnabled: false,
      registerDis: !sendRegisterAddress,
      delay: 0
    )

    // Keep pusing data..
    for index in 0 ..< size {
      // We need to kick off the transaction
      try write(
        bank: 3,
        command: ICM20498Bank3Register.i2cPeripheral4Control,
        data: controlRegister
      )

      try pollForPeripheral4Completion()

      readData[index] = try read(
        bank: 3,
        command: ICM20498Bank3Register.i2cPeripheral4DataInput
      )
    }

    return readData
  }
}
