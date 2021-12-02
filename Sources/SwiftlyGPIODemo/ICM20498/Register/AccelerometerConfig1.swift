class AccelerometerConfig: BitStruct {
  enum Scale: UInt8 {
    case scale2g
    case scale4g
    case scale8g
    case scale16g
  }

  enum LowPassConfig: UInt8 {
    case db2460_n2650
    case db2460_n2650_1
    case db1114_nw1360
    case db504_nw688
    case db239_nw344
    case db115_nw170
    case db57_nw83
    case db473_nw499
  }

  // Couldn't find good enums. This is 0 0 7
  var lowpassFilterConfig: LowPassConfig {
    set { set(bitNumber: 5, data: newValue.rawValue, length: 3) }
    get {
      guard let configValue = LowPassConfig(
        rawValue: get(bitNumber: 5, length: 3)
      ) else {
        fatalError("Invalid config value.")
      }

      return configValue
    }
  }

  var scale: Scale {
    set { set(bitNumber: 2, data: newValue.rawValue, length: 2) }
    get {
      guard let scaleValue = Scale(
        rawValue: get(bitNumber: 2, length: 2)
      ) else {
        fatalError("Invalid scale value")
      }

      return scaleValue
    }
  }

  var lowPassFilterEnabled: Bool {
    get { return isEnabled(bitNumber: 0) }
    set { enable(bitNumber: 0, newValue) }
  }
}
