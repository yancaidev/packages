import 'package:pigeon/pigeon.dart';

/// Hello world!
class Hello {
  const Hello({required this.name});

  /// 名字
  final String name;
}

/// host 平台提供的接口
@HostApi()
abstract class HelloHostApi {
  /// say hello to host api;
  @ObjCSelector('sayHelloToHostApi:')
  void sayHelloToHostApi(Hello hello);

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
