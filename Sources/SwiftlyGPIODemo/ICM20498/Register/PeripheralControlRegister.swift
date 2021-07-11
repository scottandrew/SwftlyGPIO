class PerihperalControlRegister: BitStruct { 
  enum GroupBehavior { 
    case oddNumberEndsGroup
    case evenNumberEndsGroup
  }

  init(
    enabled: Bool,
    swapBytes: Bool,
    registerDis: Bool,
    groupBehavior: GroupBehavior,
    bytesToRead: UInt8
  ) {
    super.init()
    
    self.enabled = enabled
    self.swapBytes = swapBytes
    self.registerDis = registerDis
    self.groupBehavior = groupBehavior
    self.bytesToRead = bytesToRead
  }

  required init(value: UInt8 = 0) {
    super.init(value: value)
  }

  var enabled: Bool { 
    get { isEnabled(bitNumber: 7) }
    set { enable(bitNumber: 7, newValue) }
  }

  var swapBytes: Bool { 
    get { isEnabled(bitNumber: 6) }
    set { enable(bitNumber: 6, newValue) }
  }

  var registerDis: Bool { 
    get { isEnabled(bitNumber: 5 )}
    set { enable(bitNumber: 5, newValue) }
  }

  var groupBehavior: GroupBehavior { 
    get { isEnabled(bitNumber: 4) ? .evenNumberEndsGroup : .oddNumberEndsGroup }
    set { enable(bitNumber: 4, newValue == .evenNumberEndsGroup) }
  }

  var bytesToRead: UInt8 { 
    get { return get(bitNumber: 3, length: 4) }
    set { set(bitNumber: 3, data: newValue, length: 4)}
  }
}