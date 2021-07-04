import Glibc
import libi2c

enum I2CDeviceError: Error {
  case error(number: Int32)
}

open class I2CDevice {
  private var handle: Int32 = -1
  private var deviceNumber: Int = -1
  private var address: Int32 = -1

  public init() {}

  deinit {
    close()
  }

  public func open(deviceNumber: Int, address: Int32) throws {
    let device = "/dev/i2c-\(deviceNumber)"
    handle = Glibc.open(device.cString(using: .ascii)!, O_RDWR)

    if handle < 0 {
      throw I2CDeviceError.error(number: errno)
    }

    if ioctl(handle, UInt(I2C_SLAVE), address) < 0 {
      throw I2CDeviceError.error(number: errno)
    }

    self.address = address
    self.deviceNumber = deviceNumber
  }

  public func close() {
    Glibc.close(handle)
  }

  public func readWord(command: Int) -> Int32 {
    return i2c_smbus_read_word_data(handle, UInt8(truncatingIfNeeded: command))
  }

  @discardableResult
  public func writeWord(command: Int, data: UInt16) throws -> Int {
    let result = i2c_smbus_write_word_data(handle, UInt8(truncatingIfNeeded: command), data)
    
    if result < 0 {
      throw (I2CDeviceError.error(number: errno))
    }

    return Int(result)
  }

  public func readByteData(command: Int) -> UInt8 {
    return UInt8(truncatingIfNeeded: i2c_smbus_read_byte_data(handle, UInt8(truncatingIfNeeded: command)))
  }

  @discardableResult
  public func writeByteData(command: Int, data: UInt8) throws -> Int {
    let result = i2c_smbus_write_byte_data(handle, UInt8(truncatingIfNeeded: command), data) 

    if result < 0 {
      throw (I2CDeviceError.error(number: errno))
    }

    return Int(result)
  }

  public func writeBits(command: Int, bitNumber: Int, data: UInt8, length: Int) throws {
    var byte = UInt8(readByteData(command: command))
    let mask = UInt8((1 << length) - 1) << (bitNumber - length + 1)
    var dataToWrite = data

    dataToWrite <<= (bitNumber - length + 1)
    dataToWrite &= mask
    byte &= ~mask
    byte |= dataToWrite

    try writeByteData(command: command, data: byte)
  }

  public func writeBit(command: Int, bitNumber: Int, enabled: Bool) throws {
    try writeBits(command: command, bitNumber: bitNumber, data: enabled ? 1 : 0, length: 1)
  }


  public func readBits(command: Int, bitNumber: Int, length: Int) -> UInt8 {
    var byte = UInt8(readByteData(command: command))
    let mask = UInt8((1 << length) - 1) << (bitNumber - length + 1)

    byte &= mask
    byte >>= (bitNumber - length + 1)

    return byte
  }
}
