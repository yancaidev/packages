import 'package:pigeon/pigeon.dart';

/// Hello world!
class Hello {
  const Hello({required this.name, required this.deviceType});

  /// 名字
  final String name;
  final DeviceType deviceType;
}

/// host 平台提供的接口
@HostApi()
abstract class HelloHostApi {
  /// say hello to host api;
  @ObjCSelector('sayHelloToHostApi:deviceTyoe:')
  void sayHelloToHostApi(Hello hello, DeviceType deviceType);

  /// 异步做工
  @async
  @ObjCSelector('doWork:')
  void doWork(int duration);
}

/// flutter 平台提供的接口
@FlutterApi()
abstract class HelloFlutterApi {
  /// say hello to flutter api;
  /// - hello 参数
  @ObjCSelector('sayHelloToFlutterApi:')
  void sayHelloToFlutterApi(Hello hello);
}

enum DeviceType {
  /// 未知
  @EnumValue(1)
  unknown,

  /// iPhone
  @EnumValue(200)
  iPhone,

  /// iPad
  @EnumValue(201)
  iPad,

  /// iPod
  @EnumValue(202)
  iPod,

  /// 模拟器
  @EnumValue(203)
  simulator,
}
