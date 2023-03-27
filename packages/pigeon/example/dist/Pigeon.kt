// Autogenerated from Pigeon (v9.1.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package dev.flutter.pigeon


/**
 * Hello world!
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class Hello (
  /** 名字 */
  val name: String

) {
}
/**
 * host 平台提供的接口
 *
 * Generated interface from Pigeon that represents a handler of messages from Flutter.
 */
interface HelloHostApi {
  /** say hello to host api; */
  fun sayHelloToHostApi(hello: Hello)
  /** 异步做工 */
  fun doWork(duration: Long, callback: (Result<Unit>) -> Unit)

}
