// Autogenerated from Pigeon (v9.1.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif



private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

/// Hello world!
///
/// Generated class from Pigeon that represents data sent in messages.
struct Hello {
  /// 名字
  var name: String

  static func fromList(_ list: [Any]) -> Hello? {
    let name = list[0] as! String

    return Hello(
      name: name
    )
  }
  func toList() -> [Any?] {
    return [
      name,
    ]
  }
}
private class HelloHostApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return Hello.fromList(self.readValue() as! [Any])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class HelloHostApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? Hello {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class HelloHostApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return HelloHostApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return HelloHostApiCodecWriter(data: data)
  }
}

class HelloHostApiCodec: FlutterStandardMessageCodec {
  static let shared = HelloHostApiCodec(readerWriter: HelloHostApiCodecReaderWriter())
}

/// host 平台提供的接口
///
/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol HelloHostApi {
  /// say hello to host api;
  func sayHelloToHostApi(hello: Hello) throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class HelloHostApiSetup {
  /// The codec used by HelloHostApi.
  static var codec: FlutterStandardMessageCodec { HelloHostApiCodec.shared }
  /// Sets up an instance of `HelloHostApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: HelloHostApi?) {
    /// say hello to host api;
    let sayHelloToHostApiChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.HelloHostApi.sayHelloToHostApi", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      sayHelloToHostApiChannel.setMessageHandler { message, reply in
        let args = message as! [Any]
        let helloArg = args[0] as! Hello
        do {
          try api.sayHelloToHostApi(hello: helloArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      sayHelloToHostApiChannel.setMessageHandler(nil)
    }
  }
}
private class HelloFlutterApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return Hello.fromList(self.readValue() as! [Any])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class HelloFlutterApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? Hello {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class HelloFlutterApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return HelloFlutterApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return HelloFlutterApiCodecWriter(data: data)
  }
}

class HelloFlutterApiCodec: FlutterStandardMessageCodec {
  static let shared = HelloFlutterApiCodec(readerWriter: HelloFlutterApiCodecReaderWriter())
}

/// flutter 平台提供的接口
///
/// Generated class from Pigeon that represents Flutter messages that can be called from Swift.
class HelloFlutterApi {
  private let binaryMessenger: FlutterBinaryMessenger
  init(binaryMessenger: FlutterBinaryMessenger){
    self.binaryMessenger = binaryMessenger
  }
  var codec: FlutterStandardMessageCodec {
    return HelloFlutterApiCodec.shared
  }
  /// say hello to flutter api;
  func sayHelloToFlutterApi(hello helloArg: Hello, completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.HelloFlutterApi.sayHelloToFlutterApi", binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([helloArg] as [Any?]) { _ in
      completion()
    }
  }
}
