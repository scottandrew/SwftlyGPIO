import Foundation
import libgpiod

enum GPIOLineDirection {
  case output
  case input
}

class GPIOLine {
  private let line: OpaquePointer

  deinit {
    release()
  }

  init(line: OpaquePointer) {
    self.line = line
  }

  func requestDirection(direction: GPIOLineDirection, defaultValue: Int32 = 0) throws {
    switch direction {
    case .output:
      guard gpiod_line_request_output(line, "", defaultValue) > -1 else { 
        throw GPIOError.error(number: errno) 
      }

    case .input: 
      guard gpiod_line_request_input(line, "") > -1 else { 
        throw GPIOError.error(number: errno) 
      }
    }
  }

  func writeValue(value: Int32) throws {
    guard gpiod_line_set_value(line, value) > -1 else {
      throw GPIOError.error(number: errno)
    }
  }

  func readValue() throws -> Int32 {
    let value = gpiod_line_get_value(line)

    if value == -1 {
      throw GPIOError.error(number: errno)
    }

    return value
  }

  func release() {
    gpiod_line_release(line)
  }
}
