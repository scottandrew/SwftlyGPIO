class i2cMasterStatus: BitStruct { 
  var slave0NACK: Bool { 
    get { 
      return isEnabled(bitNumber: 0)
    }
  }

  var slave1NACK: Bool { 
    return isEnabled(bitNumber: 1)
  }

    var slave2NACK: Bool { 
    return isEnabled(bitNumber: 2)
  }

  var slave3NACK: Bool { 
    return isEnabled(bitNumber: 3)
  }

  var slave4NACK: Bool { 
    return isEnabled(bitNumber: 4)
  }

  var lostAribtration: Bool { 
    return isEnabled(bitNumber: 5)
  }

  var isSlave4Done: Bool { 
    return isEnabled(bitNumber: 6)
  }

  var isFSYNCPassthrough: Bool { 
    return isEnabled(bitNumber: 7)
  }

}