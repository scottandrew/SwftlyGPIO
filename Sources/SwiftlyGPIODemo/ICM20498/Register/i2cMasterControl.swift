class i2cMasterControl: BitStruct { 
  enum PeripheralTranstion { 
    case restart
    case stop
  }

  var isMultiMasterEnabled: Bool { 
    get { return isEnabled(bitNumber: 7) }
    set { enable(bitNumber: 7, newValue) }
  }

  var peripheralTransition: PeripheralTranstion { 
    get { return isEnabled(bitNumber: 4) ? .stop : .restart}
    set { enable(bitNumber: 4, newValue == .stop) }
  }

  var clockFrequency: UInt8 { 
    get { return get(bitNumber: 3, length: 4) }
    set { set(bitNumber: 3, data: newValue, length: 4) }
  }
}