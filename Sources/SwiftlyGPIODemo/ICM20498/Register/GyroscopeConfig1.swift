class GyroscopeConfig1: BitStruct {
  enum Scale: UInt8 {
    case scale250dps
    case scale500dps
    case scale1000dps
    case scale2000dps
  }

  enum LowPassConfig: UInt8 { 
    case db1966_nw2298
    case db1518_nw1876
    case db1195_nw1543
    case db512_nw733
    case db239_nw359
    case db116_nw178
    case db57_nw89
    case db3614_nw3765
  }

  var lowPassFilterConfig: LowPassConfig {
    get { 
      guard let filterConfig =  LowPassConfig(
        rawValue: get(bitNumber: 5, length: 3) 
      ) else { 
        fatalError("Invalid gryoscrope lowpass config")
      }

      return filterConfig;
    }
    set { set(bitNumber: 5, data: newValue.rawValue, length: 3) }
  }

  var scale: Scale {
    set { set(bitNumber: 2, data: newValue.rawValue, length: 2) }
    get {
      guard let scaleValue = Scale(
        rawValue: get(bitNumber: 2, length: 2)
      ) else {
        fatalError("Invalid gryoscop scale value")
      }

      return scaleValue
    }
  }

  var lowPassFilterEnabled: Bool {
    get { return isEnabled(bitNumber: 0) }
    set { return enable(bitNumber: 0, newValue) }
  }
}
