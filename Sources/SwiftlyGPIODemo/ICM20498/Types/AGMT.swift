struct AGMT {
  let acceleromter: Axis
  let gyroscope: Axis
  let magnetometer: Axis
  let temperature: Int

  let accellerometerScale: AccelerometerConfig.Scale
  let gryoscopeScale: GyroscopeConfig1.Scale

  let magnetometerStatus1: UInt8
  let magnetometerStatus2: UInt8
}
