
expect class Hello {
  var name: String?
  var deviceType: DeviceType
  var age: Long

  constructor  (
    name: String? = null,
    deviceType: DeviceType,
    age: Long
  )
}

expect class Hi {
  var name: String
  var deviceType: DeviceType
  var age: Long

  constructor  (
    name: String,
    deviceType: DeviceType,
    age: Long
  )
}

expect class Hb {

  constructor  (
  )
}
