
package dev.flutter.pigeon

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

@Suppress("UNCHECKED_CAST")
private object HelloHostApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          Hello.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is Hello -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

@Suppress("UNCHECKED_CAST")
fun HelloHostApi.Component.setup()
{
  /** The codec used by HelloHostApi. */
  val codec: MessageCodec<Any?> by lazy {
    HelloHostApiCodec
  }
  /** Sets up an instance of `HelloHostApi` to handle messages through the `binaryMessenger`. */
  @Suppress("UNCHECKED_CAST")
  fun setUp(binaryMessenger: BinaryMessenger, api: HelloHostApi?) {
    run {
      val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.HelloHostApi.sayHelloToHostApi", codec)
      if (api != null) {
        channel.setMessageHandler { message, reply ->
          val args = message as List<Any?>
          val helloArg = args[0] as Hello
          var wrapped: List<Any?>
          try {
            api.sayHelloToHostApi(helloArg)
            wrapped = listOf<Any?>(null)
          } catch (exception: Throwable) {
            wrapped = wrapError(exception)
          }
          reply.reply(wrapped)
        }
      } else {
        channel.setMessageHandler(null)
      }
    }
    run {
      val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.HelloHostApi.doWork", codec)
      if (api != null) {
        channel.setMessageHandler { message, reply ->
          val args = message as List<Any?>
          val durationArg = args[0].let { if (it is Int) it.toLong() else it as Long }
          api.doWork(durationArg) { result: Result<Unit> ->
            val error = result.exceptionOrNull()
            if (error != null) {
              reply.reply(wrapError(error))
            } else {
              reply.reply(wrapResult(null))
            }
          }
        }
      } else {
        channel.setMessageHandler(null)
      }
    }
  }
}
@Suppress("UNCHECKED_CAST")
private object HelloFlutterApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          Hello.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is Hello -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/**
 * flutter 平台提供的接口
 *
 * Generated class from Pigeon that represents Flutter messages that can be called from Kotlin.
 */
@Suppress("UNCHECKED_CAST")
class HelloFlutterApi(private val binaryMessenger: BinaryMessenger) {
  companion object {
    /** The codec used by HelloFlutterApi. */
    val codec: MessageCodec<Any?> by lazy {
      HelloFlutterApiCodec
    }
  }
  /**
   * say hello to flutter api;
   * - hello 参数
   */
  fun sayHelloToFlutterApi(helloArg: Hello, callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.HelloFlutterApi.sayHelloToFlutterApi", codec)
    channel.send(listOf(helloArg)) {
      callback()
    }
  }
}
