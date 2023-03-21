// Autogenerated from Pigeon (v9.1.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package dev.flutter.pigeon

import android.util.Log

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/**
 * Hello world!
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class Hello (
  /** 名字 */
  val name: String

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): Hello {
      val name = list[0] as String
      return Hello(name)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      name,
    )
  }
}
