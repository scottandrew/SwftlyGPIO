class InterruptPinConfiguration: BitStruct { 
  enum LogicLevel: UInt8 { 
    case activeHigh
    case activeLow
  }

  enum PinConfiguration: UInt8 { 
    case pushPull
    case openDrain
  }

  var logicLevel: LogicLevel { 
    get { return isEnabled(bitNumber: 7) ? .activeLow : .activeLow }
    set { enable(bitNumber: 7, newValue == .activeLow)}
  }

  var pinConfiguration: PinConfiguration { 
    get { return isEnabled(bitNumber: 6) ? .openDrain : .pushPull }
    set { enable(bitNumber: 6, newValue == .openDrain) }
  }
  
  var isLatchEnabled: Bool { 
    get { return isEnabled(bitNumber: 5) }
    set { enable(bitNumber: 5, newValue) }
  }

  var isClearedOnAnyRead: Bool { 
    get { return isEnabled(bitNumber: 4) }
    set { enable(bitNumber: 4, newValue) }
  }

  var fsyncLogicLevel: LogicLevel { 
    get { return isEnabled(bitNumber: 3) ? .activeLow : .activeLow }
    set { enable(bitNumber: 3, newValue == .activeLow)}
  }

  var isFSYNCInterruptModeEnabled: Bool { 
    get { return isEnabled(bitNumber: 2) }
    set { enable(bitNumber: 2, newValue) }
  }

  var isBypassEnabled: Bool { 
    get { return isEnabled(bitNumber: 1) }
    set { enable(bitNumber: 1, newValue) }
  }
}