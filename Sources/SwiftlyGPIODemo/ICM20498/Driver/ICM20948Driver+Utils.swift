import Foundation

extension ICM20948Driver {
  func enableMaster(enable: Bool) throws { 
    try enableMasterI2CMasterPassthrough(false)
    
    // read our master controller.
    let control: i2cMasterControl = try read(bank: 3, command: ICM20498Bank3Register.i2cMasterControl)

    control.clockFrequency = 0x07
    control.peripheralTransition = .stop

    try write(bank: 3, command: ICM20498Bank3Register.i2cMasterControl, data: control)

    try enableI2CMaster(enable)
  }

  // some code to read all sensors at once.
  readSensors
}