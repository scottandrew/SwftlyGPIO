class UserControl: BitStruct { 
  var isDMPEnabled: Bool { 
    get { return isEnabled(bitNumber: 7) }
    set { enable(bitNumber: 7, newValue) }
  }

  var isFIFOEnabled: Bool { 
    get { return isEnabled(bitNumber: 6) }
    set { enable(bitNumber: 6, newValue) }
  }

  var isI2CMasterEnabled: Bool { 
    get { return isEnabled(bitNumber: 5) }
    set { enable(bitNumber: 5, newValue) }
  }

  func resetPeripheralModule() { 
    enable(bitNumber: 4, true)
  }

  func resetDMPModule() { 
    enable(bitNumber: 3, true)
  }

  func resetSRAM() { 
    enable(bitNumber: 2, true)
  }

  func resetI2CMaster() {
    enable(bitNumber: 1, true)
  }
}