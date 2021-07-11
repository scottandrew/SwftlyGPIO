class PeripheralAddressRegister: BitStruct {
  enum TransferMode: UInt8 {
    case write = 0
    case read = 1
  }

  init(address: UInt8, mode: TransferMode = .read) {
    super.init()
    self.address = address
    self.mode = mode
  }

  required init(value: UInt8 = 0) {
    super.init(value: value)
  }

  var address: UInt8 {
    get {
      return get(bitNumber: 6, length: 7)
    }
    set {
      set(bitNumber: 6, data: newValue, length: 7)
    }
  }

  var mode: TransferMode {
    get {
      return isEnabled(bitNumber: 7) ? .read : .write
    }
    set {
      enable(bitNumber: 7, newValue == .read)
    }
  }
}
