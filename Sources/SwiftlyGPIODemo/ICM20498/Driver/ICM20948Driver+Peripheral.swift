import Foundation

extension ICM20948Driver { 
  func i2cPeripheralWriteToConfiguration(
    peripheral: UInt8, 
    address: UInt8, 
    register: UInt8, 
    data: UInt8
  ) throws { 
    let peripheralRegisters = try ICM20498Bank3Register.PeripheralRegisters(number: peripheral)
    let addressRegister = PeripheralAddressRegister(address: address, mode: .write)

    // set up the address.. 
    try write(bank: 3, command: peripheralRegisters.address, data: addressRegister)
    
    // setup the data out.
    try write(bank: 3, command: peripheralRegisters.dataOut, data: data)

    // setup the register
    try write(bank: 3, command: peripheralRegisters.register, data: register)

    // Setup control and set
    let peripheralControl = PerihperalControlRegister(
      enabled: true, 
      swapBytes: false, 
      registerDis: false, 
      groupBehavior: .oddNumberEndsGroup, 
      bytesToRead: 1
    )

    try write(bank: 3, command: peripheralRegisters.control, data: peripheralControl)
  }

  func i2cPeripheralConfigureForReading(
    peripheral: UInt8, 
    address: UInt8, 
    register: UInt8, 
    readLength: UInt8,
    dataOnly: Bool,
    groupBehavior: PerihperalControlRegister.GroupBehavior,
    swap: Bool
  ) throws { 
    let peripheralRegisters = try ICM20498Bank3Register.PeripheralRegisters(number: peripheral)
    let addressRegister = PeripheralAddressRegister(address: address, mode: .read)

    // set up the address.. 
    try write(bank: 3, command: peripheralRegisters.address, data: addressRegister)
  
      // setup the register
    try write(bank: 3, command: peripheralRegisters.register, data: register)

    // Setup control and set
    let peripheralControl = PerihperalControlRegister(
      enabled: true, 
      swapBytes: swap, 
      registerDis: dataOnly, 
      groupBehavior: groupBehavior, 
      bytesToRead: readLength
    )

    try write(bank: 3, command: peripheralRegisters.control, data: peripheralControl)
  }
}