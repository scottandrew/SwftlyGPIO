protocol RegisterProtocol: RawRepresentable { 
  var register: UInt8 {get}
}

extension RegisterProtocol { 
  var register: UInt8 { return rawValue as? UInt8 ?? 0 }
}