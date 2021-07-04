import Foundation

extension ICM20948Driver { 

  internal func i2cControllerPeripherial4TransactionWrite(
    address: UInt8,
    register: UInt8,
    data: Data,
    sendRegisterAddress: Bool
  ) throws {
    let addressData = PeripheralAddressRegister()

    addressData.address = address
    addressData.transferMode = .write

    try write(bank: 3, command: ICM20498Bank3Register.i2cPeripheral4Address, data: addressData)
    try write(bank: 3, command: ICM20498Bank3Register.i2cPeripheral4Register, data: register)

    let controlRegister = PeripheralControlRegister()
    controlRegister.isEnabled = true
    controlRegister.isInterruptEnabled = false
    controlRegister.delay = 0
    controlRegister.registerDis = !sendRegisterAddress

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

      let maxTries = 1000
      var count = 0

      while count < maxTries {
        // we need to keep reading the status register to see when it
        // tells us it is done.
         let status: i2cMasterStatus = try read(bank: 0, command: ICM20498Bank0Register.i2cMasterStatus)
         
        if status.isSlave4Done {
          break
        }

        count += 1
      }

      if (count >= maxTries) {
        throw ICM20498Error.peripheral4TransactionFailed
      }
    }
  }

  internal func i2cControllerPeripherial4TransactionRead(
    address: UInt8,
    register: UInt8,
    size: Int,
    sendRegisterAddress: Bool
  ) throws -> Data {
    let addressData = PeripheralAddressRegister()
    var readData = Data(count: size)

    addressData.address = address
    addressData.transferMode = .read

    try write(bank: 3, command: ICM20498Bank3Register.i2cPeripheral4Address, data: addressData)
    try write(bank: 3, command: ICM20498Bank3Register.i2cPeripheral4Register, data: register)

    let controlRegister = PeripheralControlRegister()
    controlRegister.isEnabled = true
    controlRegister.isInterruptEnabled = false
    controlRegister.delay = 0
    controlRegister.registerDis = !sendRegisterAddress

    // Keep pusing data..
    for index in 0 ..< size {
      // We need to kick off the transaction
      try write(
        bank: 3,
        command: ICM20498Bank3Register.i2cPeripheral4Control,
        data: controlRegister
      )

      let maxTries = 1000
      var count = 0

      while count < maxTries {
        // we need to keep reading the status register to see when it
        // tells us it is done.
        let status: i2cMasterStatus = try read(bank: 0, command: ICM20498Bank0Register.i2cMasterStatus)

        print(status.value);

        if status.isSlave4Done {
          break
        }

        count += 1
      }

      if count >= maxTries {
        throw ICM20498Error.peripheral4TransactionFailed
      }

      readData[index] = try read(
        bank: 3,
        command: ICM20498Bank3Register.i2cPeripheral4DataInput
      )
    }

    return readData
  }
}