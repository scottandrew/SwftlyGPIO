class SlaveAddressRegister: BitStruct { 
  enum Bits: Int { 
    case address = 0x6
    case transferMode = 0x7
  }

  enum TransferMode: UInt8 { 
    case write
    case read
  }

  let addressLength = 7

  var address: UInt8 { 
    get { 
      return get(bitNumber: Bits.address.rawValue, length: addressLength)
    }
    set { 
      set(bitNumber: Bits.address.rawValue, data: newValue, length: addressLength)
    }
  }

    var transferMode: TransferMode { 
      get { 
        return TransferMode(rawValue: get(bitNumber: Bits.transferMode.rawValue, length: 1))!
      }
      set { 
        set(bitNumber: Bits.transferMode.rawValue, data: newValue.rawValue, length: 1)
      }
    }
  }
