import Foundation
import libgpiod

enum GPIOError: Error {
  case error(number: Int32)
}

class GPIOChip {
  private let chip: OpaquePointer

  deinit { 
    close();
  }

  init(name: String) throws {
    guard let chip = gpiod_chip_open_by_name(name.cString(using: .ascii)) else {
      throw GPIOError.error(number: errno)
    }

    self.chip = chip
  }

  func line(number: UInt32) throws -> GPIOLine {
    guard let line = gpiod_chip_get_line(chip, number) else {
      throw GPIOError.error(number: errno)
    }
    
    return GPIOLine(line: line)
  }

  func close() { 
    gpiod_chip_close(chip);
  }
}
