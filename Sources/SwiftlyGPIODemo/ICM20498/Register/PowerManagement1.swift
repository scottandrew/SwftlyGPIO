class PowerManagement1: BitStruct {
  enum ClockSource: UInt8 { 
    case internal20MhzOscillator1
    case autoSelect
    case interlal20MhzOscillator2
    case stopAndKeepInReset
  }

  var resetDevice: Bool {
    get { return isEnabled(bitNumber: 7) }
    set { enable(bitNumber: 7, newValue) }
  }

  var sleep: Bool {
    get { return isEnabled(bitNumber: 6) }
    set { enable(bitNumber: 6, newValue) }
  }

  var enableLowPower: Bool { 
    get { return isEnabled(bitNumber: 5) }
    set { enable(bitNumber: 5, newValue)}
  }

  var isTemperatureSensorDisabled: Bool { 
    get { return isEnabled(bitNumber: 3)}
    set { enable(bitNumber: 3, newValue)}
  }

  var clockSource: ClockSource { 
    get { return ClockSource(rawValue: get(bitNumber: 2, length: 3)) ?? .internal20MhzOscillator1 }
    set { set(bitNumber: 2, data: newValue.rawValue, length: 3) }
  }
}
