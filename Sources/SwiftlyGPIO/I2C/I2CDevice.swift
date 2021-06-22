import Glibc
import libi2c

enum I2CDeviceError: Error {
  case error(number: Int32)
}

class I2CDevice {
  private var handle: Int32 = -1
  private var deviceNumber: Int = -1
  private var address: Int32 = -1

  deinit {
    close()
  }

  func open(deviceNumber: Int, address: Int32) throws {
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

  func close() {
    Glibc.close(handle)
  }

  func readWord(command: Int) -> Int32 {
    return i2c_smbus_read_word_data(handle, UInt8(truncatingIfNeeded: command))
  }

  func writeWord(command: Int, data: UInt16) throws {
    if i2c_smbus_write_word_data(handle, UInt8(truncatingIfNeeded: command), data) < 0 {
      throw (I2CDeviceError.error(number: errno))
    }
  }

  func readByteData(command: Int) -> Int8 {
    return Int8(truncatingIfNeeded: i2c_smbus_read_byte_data(handle, UInt8(truncatingIfNeeded: command)))
  }

  func writeByteData(command: Int, data: UInt8) throws {
    if i2c_smbus_write_byte_data(handle, UInt8(truncatingIfNeeded: command), UInt8(truncatingIfNeeded: data)) < 0 {
      throw (I2CDeviceError.error(number: errno))
    }
  }

  func writeBits(command: Int, bitNumber: Int, data: UInt8, length: Int) throws {
    var byte = UInt8(readByteData(command: command))
    let mask = UInt8((1 << length) - 1) << (bitNumber - length + 1)
    var dataToWrite = data

    dataToWrite <<= (bitNumber - length + 1)
    dataToWrite &= mask
    byte &= ~mask
    byte |= dataToWrite

    try writeByteData(command: command, data: byte)
  }

  func writeBit(command: Int, bitNumber: Int, enabled: Bool) throws {
    try writeBits(command: command, bitNumber: bitNumber, data: enabled ? 1 : 0, length: 1)
  }


  func readBits(command: Int, bitNumber: Int, length: Int) -> UInt8 {
    var byte = UInt8(readByteData(command: command))
    let mask = UInt8((1 << length) - 1) << (bitNumber - length + 1)

    byte &= mask
    byte >>= (bitNumber - length + 1)

    return byte
  }
}
