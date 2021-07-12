// LP_CONFIG
class SampleModeRegister: BitStruct { 
  enum Mode { 
    case continuous
    case cycled
  }
  
  var i2cMasterMode: Mode { 
    get { return isEnabled(bitNumber: 6) ? .cycled : .continuous }
    set { enable(bitNumber: 6, newValue == .cycled) }
  }

  var accelerometerMode: Mode { 
    get { return isEnabled(bitNumber: 5) ? .cycled : .continuous }
    set { enable(bitNumber: 5, newValue == .cycled) }
  }

  var gyroscopeMode: Mode { 
    get { return isEnabled(bitNumber: 4) ? .cycled : .continuous }
    set { enable(bitNumber: 4, newValue == .cycled) }
  }
}