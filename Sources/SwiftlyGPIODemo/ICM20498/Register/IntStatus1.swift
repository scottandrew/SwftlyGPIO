class IntStatus1: BitStruct { 
  var isDataReady: Bool { 
    get { 
      return isEnabled(bitNumber: 0)
    }
    set { 
      enable(bitNumber: 0, newValue)
    }
  }
}