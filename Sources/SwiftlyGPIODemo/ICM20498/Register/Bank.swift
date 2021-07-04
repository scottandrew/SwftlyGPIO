class Bank: BitStruct {
  var userBank: UInt8 { 
    set { 
      set(bitNumber: 5, data: newValue, length: 2)
    }
    get { 
      get(bitNumber: 5, length: 2)
    }
  }
}