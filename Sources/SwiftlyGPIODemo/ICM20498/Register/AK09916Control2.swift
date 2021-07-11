class AK09916Control2: BitStruct {
  enum Mode {
    case continuous
    case single
  }

  enum SampleRate: UInt8 {
    case none
    case rate10hz
    case rate20hz
    case rate50hz
    case rate100hz
  }

  required init(mode: Mode = .continuous, sampleRate: SampleRate) {
    super.init()

    self.mode = mode
    self.sampleRate = sampleRate
  }

    required init(value: UInt8 = 0) { 
      super.init(value: value)
    }

  var mode: Mode {
    get { return isEnabled(bitNumber: 0) ? .single : .continuous }
    set { enable(bitNumber: 0, newValue == .single) }
  }

  var sampleRate: SampleRate {
    get {
      return SampleRate(rawValue: get(bitNumber: 3, length: 3)) ?? .none
    }
    set {
      set(bitNumber: 3, data: newValue.rawValue, length: 3)
    }
  }

  func powerDown() { reset() }
  func selfTest() { enable(bitNumber: 4, true) }
}
