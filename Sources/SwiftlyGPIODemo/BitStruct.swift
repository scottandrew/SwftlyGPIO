import Foundation

class BitStruct {
    private (set) var value = UInt8(0)

    required init(value: UInt8 = 0) { 
      self.value = value
    }

    func set(bitNumber: Int, data: UInt8, length: Int) {
        let mask = UInt8((1 << length) - 1) << (bitNumber - length + 1)
        var dataToWrite = data

         dataToWrite <<= (bitNumber - length + 1)
         dataToWrite &= mask
         value &= ~mask
         value |= dataToWrite
    }

    func get(bitNumber: Int, length: Int) -> UInt8 {
        let mask = UInt8((1 << length) - 1) << (bitNumber - length + 1)
        var bytes = value

        bytes &= mask
        bytes >>= (bitNumber - length + 1)

        return bytes
    }

    func enable(bitNumber: Int, _ enabled: Bool) { 
      set(bitNumber: bitNumber, data: enabled ? 1 : 0, length: 1);
    }

    func isEnabled(bitNumber: Int) -> Bool { 
      return get(bitNumber: bitNumber, length: 1) == 1
    }
}
