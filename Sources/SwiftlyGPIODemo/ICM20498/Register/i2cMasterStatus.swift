class i2cMasterStatus: BitStruct { 
  var peripheral0NACK: Bool { 
    get { 
      return isEnabled(bitNumber: 0)
    }
  }

  var peripheral1NACK: Bool { 
    return isEnabled(bitNumber: 1)
  }

    var peripheral2NACK: Bool { 
    return isEnabled(bitNumber: 2)
  }

  var peripheral3NACK: Bool { 
    return isEnabled(bitNumber: 3)
  }

  var peripheral4NACK: Bool { 
    return isEnabled(bitNumber: 4)
  }

  var lostAribtration: Bool { 
    return isEnabled(bitNumber: 5)
  }

  var isPeripheral4Done: Bool { 
    return isEnabled(bitNumber: 6)
  }

  var isFSYNCPassthrough: Bool { 
    return isEnabled(bitNumber: 7)
  }

}