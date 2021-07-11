class Peripheral4ControlRegister: BitStruct { 

  required init(isEnabled: Bool, isInterruptEnabled: Bool = false, registerDis: Bool, delay: UInt8) {
    super.init()

    self.isEnabled = isEnabled
    self.isInterruptEnabled = isInterruptEnabled
    self.registerDis = registerDis
    self.delay = delay
  }

  required init(value: UInt8 = 0) {
    super.init(value: value)
  }
  
  var isEnabled: Bool { 
    get { 
      return isEnabled(bitNumber: 7)
    }
    set { 
      enable(bitNumber: 7, newValue)
    }
  }

  var isInterruptEnabled: Bool { 
    get { 
      return isEnabled(bitNumber: 6)
    }
    set { 
      enable(bitNumber: 6, newValue)
    }
  }

  var registerDis: Bool { 
    get { 
      return isEnabled(bitNumber: 5)
    }
    set { 
      enable(bitNumber: 5, newValue)
    }
  }

  var delay: UInt8 { 
    get { 
      return get(bitNumber: 4, length: 5)
    }
    set { 
      set(bitNumber: 4, data: newValue, length: 5);
    }
  }
}