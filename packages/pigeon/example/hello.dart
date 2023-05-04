import 'package:pigeon/pigeon.dart';

/// Hello world!
class Hello {
  const Hello({
    required this.name,
    required this.deviceType,
    required this.age,
  });

  /// 名字
  final String? name;
  final DeviceType deviceType;
  final int age;
}

class Hi {
  const Hi({
    required this.name,
    required this.deviceType,
    required this.age,
  });

  /// 名字
  final String name;
  final DeviceType deviceType;
  final int age;
}

class Hb {}

/// host 平台提供的接口
@HostApi()
abstract class HelloHostApi {
  void sayHi(Hi hi, Hb hb);

  /// say hello to host api;
  @ObjCSelector('sayHelloToHostApi:deviceType:')
  @KMMObjcMethodName('say')
  void sayHelloToHostApi(Hello hello, DeviceType deviceType);

  /// 异步做工
  @async
  @ObjCSelector('doWorkInSeconds:')
  void doWorkInSeconds(int seconds);

  /// 异步做工
  @async
  @ObjCSelector('hasSalary:')
  void hasSalary(bool has);
}

/// flutter 平台提供的接口
@FlutterApi()
abstract class HelloFlutterApi {
  /// say hello to flutter api;
  /// - hello 参数
  @ObjCSelector('sayHelloToFlutterApi:')
  void sayHelloToFlutterApi(Hello hello);
  @KMMObjcMethodName('sayToFlutterApiWith')
  void sayToFlutterApi(Hello hello);
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
