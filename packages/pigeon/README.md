# Pigeon

## flutter 特定 api 与 数据模型分离
 pigeon 自动生成的数据模型 和 flutter 与宿主平台通讯的代码放在一起。而这些 flutter 特定 api 只能依托 flutter 才能正常编译。为了
 满足通过 pigeon 生成的数据模型能够重复原生平台使用，所以将数据模型
 和 flutter 特定 api 的接口分离。使数据模型作为独立的模块，不进可以在 flutter 项目中使用，在原生平台上也能正常使用。

- **实现的原理**
通过修改代码模板实现。

- **使用**
在 iOS 中使用时，如果是 flutter 项目，需要定义 `__FLUTTER__` 宏。

- **示例**
参照 [example]('./example/generate.sh')

Pigeon is a code generator tool to make communication between Flutter and the
host platform type-safe, easier and faster.

## Supported Platforms

Currently Pigeon supports generating:
* Kotlin and Java code for Android,
* Swift and Objective-C code for iOS
* Swift code for macOS
* C++ code for Windows

## Runtime Requirements

Pigeon generates all the code that is needed to communicate between Flutter and
the host platform, there is no extra runtime requirement.  A plugin author
doesn't need to worry about conflicting versions of Pigeon.

## Usage

1) Add Pigeon as a `dev_dependency`.
1) Make a ".dart" file outside of your "lib" directory for defining the
   communication interface.
1) Run pigeon on your ".dart" file to generate the required Dart and
   host-language code: `flutter pub get` then `flutter pub run pigeon`
   with suitable arguments (see [example](./example)).
1) Add the generated Dart code to `./lib` for compilation.
1) Implement the host-language code and add it to your build (see below).
1) Call the generated Dart methods.

### Flutter calling into iOS steps

1) Add the generated Objective-C or Swift code to your Xcode project for compilation
   (e.g. `ios/Runner.xcworkspace` or `.podspec`).
1) Implement the generated protocol for handling the calls on iOS, set it up
   as the handler for the messages.

### Flutter calling into Android Steps

1) Add the generated Java or Kotlin code to your `./android/app/src/main/java` directory
   for compilation.
1) Implement the generated Java or Kotlin interface for handling the calls on Android, set
   it up as the handler for the messages.

### Flutter calling into Windows Steps

1) Add the generated C++ code to your `./windows` directory for compilation, and
   to your `windows/CMakeLists.txt` file.
1) Implement the generated C++ abstract class for handling the calls on Windows,
   set it up as the handler for the messages.

### Flutter calling into macOS steps

1) Add the generated Objective-C or Swift code to your Xcode project for compilation
   (e.g. `macos/Runner.xcworkspace` or `.podspec`).
1) Implement the generated protocol for handling the calls on macOS, set it up
   as the handler for the messages.

### Calling into Flutter from the host platform

Flutter also supports calling in the opposite direction.  The steps are similar
but reversed.  For more information look at the annotation `@FlutterApi()` which
denotes APIs that live in Flutter but are invoked from the host platform.

### Rules for defining your communication interface

1) The file should contain no method or function definitions, only declarations.
1) Custom classes used by APIs are defined as classes with fields of the
   supported datatypes (see the supported Datatypes section).
1) APIs should be defined as an `abstract class` with either `HostApi()` or
   `FlutterApi()` as metadata.  The former being for procedures that are defined
   on the host platform and the latter for procedures that are defined in Dart.
1) Method declarations on the API classes should have arguments and a return
   value whose types are defined in the file, are supported datatypes, or are
   `void`.
1) Generics are supported, but can currently only be used with nullable types
   (example: `List<int?>`).

## Supported Datatypes

Pigeon uses the `StandardMessageCodec` so it supports any datatype Platform
Channels supports
[[documentation](https://flutter.dev/docs/development/platform-integration/platform-channels#codec)].
Nested datatypes are supported, too.

## Features

### Asynchronous Handlers

By default Pigeon will generate synchronous handlers for messages and
asynchronous methods. If you want a handler to be able to respond to a message
asynchronously you can use the @async annotation as of version 0.1.20.

Example:

```dart
class Value {
  int? number;
}

@HostApi()
abstract class Api2Host {
  @async
  Value calculate(Value value);
}
```

Generates:

```objc
// Objective-C
@protocol Api2Host
-(void)calculate:(nullable Value *)input
      completion:(void(^)(Value *_Nullable, FlutterError *_Nullable))completion;
@end
```

```swift
// Swift

/** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
protocol Api2Host {
  func calculate(value: Value, completion: @escaping (Value) -> Void)
}
```

```java
// Java
public interface Result<T> {
   void success(T result);
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
public interface Api2Host {
   void calculate(Value arg, Result<Value> result);
}
```

```kotlin
// Kotlin

/** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
interface Api2Host {
   fun calculate(value: Value, callback: (Result<Value>) -> Unit)
}
```

```c++
// C++

/** Generated class from Pigeon that represents a handler of messages from Flutter.*/
class Api2Host {
public:
    virtual void calculate(Value value, flutter::MessageReply<Value> result) = 0;
}
```

### Null Safety (NNBD)

Pigeon supports generating null-safe code, but it doesn't yet support:

1) Nullable generics type arguments
1) Nullable enum arguments to methods

### Enums

Pigeon supports enum generation in class fields.  For example:
```dart
enum State {
  pending,
  success,
  error,
}

class StateResult {
  String? errorMessage;
  State? state;
}

@HostApi()
abstract class Api {
  StateResult queryState();
}
```

### Primitive Data-types

Prior to version 1.0 all arguments to API methods had to be wrapped in a class, now they can be used directly.  For example:

```dart
@HostApi()
abstract class Api {
   Map<String?, int?> makeMap(List<String?> keys, List<String?> values);
}
```

### TaskQueues

When targeting a Flutter version that supports the
[TaskQueue API](https://docs.flutter.dev/development/platform-integration/platform-channels?tab=type-mappings-kotlin-tab#channels-and-platform-threading)
the threading model for handling HostApi methods can be selected with the
`TaskQueue` annotation:

```dart
@HostApi()
abstract class Api2Host {
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  int add(int x, int y);
}
```

### Error Handling

#### Kotlin, Java and Swift

All Host API exceptions are translated into Flutter `PlatformException`.
* For synchronous methods, thrown exceptions will be caught and translated.
* For asynchronous methods, there is no default exception handling; errors should be returned via the provided callback.

To pass custom details into `PlatformException` for error handling, use `FlutterError` in your Host API.
For example:

```kotlin
// Kotlin
class MyApi : GeneratedApi {
  // For synchronous methods
  override fun doSomething() {
    throw FlutterError('error_code', 'message', 'details')
  }

  // For async methods
  override fun doSomethingAsync(callback: (Result<Unit>) -> Unit) {
    callback(Result.failure(FlutterError('error_code', 'message', 'details'))
  }
}
```

#### Objective-C and C++

Likewise, Host API errors can be sent using the provided `FlutterError` class (translated into `PlatformException`).

For synchronous methods:
* Objective-C - Assign the `error` argument to a `FlutterError` reference.
* C++ - Return a `FlutterError` directly (for void methods) or within an `ErrorOr` instance.

For async methods:
* Both - Return a `FlutterError` through the provided callback.

#### Handling the errors

Then you can implement error handling on the Flutter side:

```dart
// Dart
void doSomething() {
  try {
    myApi.doSomething()
  } catch (PlatformException e) {
    if (e.code == 'error_code') {
      // Perform custom error handling
      assert(e.message == 'message')
      assert(e.details == 'details')
    }
  }
}
```

## Feedback

File an issue in [flutter/flutter](https://github.com/flutter/flutter) with the
word "pigeon" in the title.
