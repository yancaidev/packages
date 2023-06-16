// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'ast.dart';
import 'functional.dart';
import 'generator.dart';
import 'generator_tools.dart';
import 'pigeon_lib.dart' show TaskQueueType;

/// Documentation open symbol.
const String _docCommentPrefix = '/**';

/// Documentation continuation symbol.
const String _docCommentContinuation = ' *';

/// Documentation close symbol.
const String _docCommentSuffix = ' */';

/// Documentation comment spec.
const DocumentCommentSpecification _docCommentSpec =
    DocumentCommentSpecification(
  _docCommentPrefix,
  closeCommentToken: _docCommentSuffix,
  blockContinuationToken: _docCommentContinuation,
);

/// Options that control how Kotlin code will be generated.
class KotlinOptions {
  /// Creates a [KotlinOptions] object
  const KotlinOptions({
    this.package,
    this.copyrightHeader,
    this.errorClassName,
    this.output,
    this.writeModelsOnly,
    this.writeForKMM,
  });

  /// Whether to write only models or all classes.
  final bool? writeModelsOnly;

  /// 为 KMM 平台生成代码
  final bool? writeForKMM;

  /// The package where the generated class will live.
  final String? package;

  /// A copyright header that will get prepended to generated code.
  final Iterable<String>? copyrightHeader;

  /// The name of the error class used for passing custom error parameters.
  final String? errorClassName;

  /// Path to the kotlin files that will be generated.
  final String? output;

  /// Creates a [KotlinOptions] from a Map representation where:
  /// `x = KotlinOptions.fromMap(x.toMap())`.
  static KotlinOptions fromMap(Map<String, Object> map) {
    return KotlinOptions(
      package: map['package'] as String?,
      copyrightHeader: map['copyrightHeader'] as Iterable<String>?,
      errorClassName: map['errorClassName'] as String?,
      writeModelsOnly: map['writeModelsOnly'] as bool?,
    );
  }

  /// Converts a [KotlinOptions] to a Map representation where:
  /// `x = KotlinOptions.fromMap(x.toMap())`.
  Map<String, Object> toMap() {
    final Map<String, Object> result = <String, Object>{
      if (package != null) 'package': package!,
      if (copyrightHeader != null) 'copyrightHeader': copyrightHeader!,
      if (errorClassName != null) 'errorClassName': errorClassName!,
      if (writeModelsOnly != null) 'writeModelsOnly': writeModelsOnly!,
    };
    return result;
  }

  /// Overrides any non-null parameters from [options] into this to make a new
  /// [KotlinOptions].
  KotlinOptions merge(KotlinOptions options) {
    return KotlinOptions.fromMap(mergeMaps(toMap(), options.toMap()));
  }
}

///
bool writeModelsOnly = false;

/// Class that manages all Kotlin code generation.
class KotlinGenerator extends StructuredGenerator<KotlinOptions> {
  /// Instantiates a Kotlin Generator.
  KotlinGenerator();

  @override
  void writeFilePrologue(
      KotlinOptions generatorOptions, Root root, Indent indent) {
    writeModelsOnly = generatorOptions.writeModelsOnly ?? false;
    if (generatorOptions.copyrightHeader != null) {
      addLines(indent, generatorOptions.copyrightHeader!, linePrefix: '// ');
    }
    indent.writeln('// ${getGeneratedCodeWarning()}');
    indent.writeln('// $seeAlsoWarning');
  }

  @override
  void writeFileImports(
      KotlinOptions generatorOptions, Root root, Indent indent) {
    indent.newln();
    if (root.supportKmm) {
      indent.writeln('@file:OptIn(ExperimentalObjCName::class)');
    }
    if (generatorOptions.package != null) {
      indent.writeln('package ${generatorOptions.package}');
    }
    if (root.supportKmm) {
      indent.writeln('import kotlin.experimental.ExperimentalObjCName');
      indent.writeln('import kotlin.native.ObjCName');
    }
    indent.newln();
    if (writeModelsOnly) {
    } else {
      indent.writeln('import android.util.Log');
      indent.writeln('import io.flutter.plugin.common.BasicMessageChannel');
      indent.writeln('import io.flutter.plugin.common.BinaryMessenger');
      indent.writeln('import io.flutter.plugin.common.MessageCodec');
      indent.writeln('import io.flutter.plugin.common.StandardMessageCodec');
      indent.writeln('import java.io.ByteArrayOutputStream');
      indent.writeln('import java.nio.ByteBuffer');
    }
  }

  @override
  void writeEnum(
      KotlinOptions generatorOptions, Root root, Indent indent, Enum anEnum) {
    indent.newln();
    if (!writeModelsOnly) {
      // 在 flutter 端不需要生成 enum，因为在 models 中已经生成了
      return;
    }
    addDocumentationComments(
        indent, anEnum.documentationComments, _docCommentSpec);
    indent.write('enum class ${anEnum.name}(val raw: Int) ');
    indent.addScoped('{', '}', () {
      enumerate(anEnum.members, (int index, final EnumMember member) {
        addDocumentationComments(
            indent, member.documentationComments, _docCommentSpec);
        indent.write('${member.name.toUpperCase()}(${member.value})');
        if (index != anEnum.members.length - 1) {
          indent.addln(',');
        } else {
          indent.addln(';');
        }
      });

      indent.newln();
      indent.write('companion object ');
      indent.addScoped('{', '}', () {
        if (root.supportKmm) {
          indent.writeln('@ObjCName("of") ');
        }
        indent.write('fun ofRaw(raw: Int): ${anEnum.name}? ');
        indent.addScoped('{', '}', () {
          indent.writeln('return values().firstOrNull { it.raw == raw }');
        });
      });
    });
  }

  @override
  void writeDataClass(
      KotlinOptions generatorOptions, Root root, Indent indent, Class klass) {
    // _writeKmmExpectClass(generatorOptions, root, indent, klass);
    final Set<String> customClassNames =
        root.classes.map((Class x) => x.name).toSet();
    final Set<String> customEnumNames =
        root.enums.map((Enum x) => x.name).toSet();
    const List<String> generatedMessages = <String>[
      // ' Generated class from Pigeon that represents data sent in messages.'
    ];
    indent.newln();
    addDocumentationComments(
        indent, klass.documentationComments, _docCommentSpec);
    if (!writeModelsOnly) {
      writeClassDecode(generatorOptions, root, indent, klass, customClassNames,
          customEnumNames);
      writeClassEncode(generatorOptions, root, indent, klass, customClassNames,
          customEnumNames);
      return;
    }

    indent.write('class ${klass.name} ');
    indent.addScoped('(', '', () {
      for (final NamedType element in getFieldsInSerializationOrder(klass)) {
        _writeClassField(indent, element);
        if (getFieldsInSerializationOrder(klass).last != element) {
          indent.addln(',');
        }
      }
    });

    indent.addScoped(') {', '}', () {
      if (writeModelsOnly) {
        indent.write('companion object ');
        indent.addScoped('{', '}', () {});
        return;
      }
      // writeClassDecode(generatorOptions, root, indent, klass, customClassNames,
      //     customEnumNames);
      // writeClassEncode(generatorOptions, root, indent, klass, customClassNames,
      //     customEnumNames);
    });
  }

  @override
  void writeClassEncode(
    KotlinOptions generatorOptions,
    Root root,
    Indent indent,
    Class klass,
    Set<String> customClassNames,
    Set<String> customEnumNames,
  ) {
    indent.write('fun ${klass.name}.toList(): List<Any?> ');
    indent.addScoped('{', '}', () {
      indent.write('return listOf<Any?>');
      indent.addScoped('(', ')', () {
        for (final NamedType field in getFieldsInSerializationOrder(klass)) {
          final HostDatatype hostDatatype = _getHostDatatype(root, field);
          String toWriteValue = '';
          final String fieldName = field.name;
          final String safeCall = field.type.isNullable ? '?' : '';
          if (!hostDatatype.isBuiltin &&
              customClassNames.contains(field.type.baseName)) {
            toWriteValue = '$fieldName$safeCall.toList()';
          } else if (!hostDatatype.isBuiltin &&
              customEnumNames.contains(field.type.baseName)) {
            toWriteValue = '$fieldName$safeCall.raw';
          } else {
            toWriteValue = fieldName;
          }
          indent.writeln('$toWriteValue,');
        }
      });
    });
  }

  @override
  void writeClassDecode(
    KotlinOptions generatorOptions,
    Root root,
    Indent indent,
    Class klass,
    Set<String> customClassNames,
    Set<String> customEnumNames,
  ) {
    final String className = klass.name;
    indent.writeln('@Suppress("UNCHECKED_CAST")');
    indent.write(
        'fun $className.Companion.fromList(list: List<Any?>): $className ');
    // indent.addScoped('{', '}', () {
    // indent.writeln('@Suppress("UNCHECKED_CAST")');
    // indent.write('fun fromList(list: List<Any?>): $className ');

    indent.addScoped('{', '}', () {
      enumerate(getFieldsInSerializationOrder(klass),
          (int index, final NamedType field) {
        final HostDatatype hostDatatype = _getHostDatatype(root, field);

        // The StandardMessageCodec can give us [Integer, Long] for
        // a Dart 'int'.  To keep things simple we just use 64bit
        // longs in Pigeon with Kotlin.
        final bool isInt = field.type.baseName == 'int';

        final String listValue = 'list[$index]';
        final String fieldType = _kotlinTypeForDartType(field.type);

        if (field.type.isNullable) {
          if (!hostDatatype.isBuiltin &&
              customClassNames.contains(field.type.baseName)) {
            indent.write('val ${field.name}: $fieldType? = ');
            indent.add('($listValue as List<Any?>?)?.let ');
            indent.addScoped('{', '}', () {
              indent.writeln('$fieldType.fromList(it)');
            });
          } else if (!hostDatatype.isBuiltin &&
              customEnumNames.contains(field.type.baseName)) {
            indent.write('val ${field.name}: $fieldType? = ');
            indent.add('($listValue as Int?)?.let ');
            indent.addScoped('{', '}', () {
              indent.writeln('$fieldType.ofRaw(it)');
            });
          } else if (isInt) {
            indent.write('val ${field.name} = $listValue');
            indent.addln('.let { ${_cast(listValue, type: field.type)} }');
          } else {
            indent.writeln(
                'val ${field.name} = ${_cast(listValue, type: field.type)}');
          }
        } else {
          if (!hostDatatype.isBuiltin &&
              customClassNames.contains(field.type.baseName)) {
            indent.writeln(
                'val ${field.name} = $fieldType.fromList($listValue as List<Any?>)');
          } else if (!hostDatatype.isBuiltin &&
              customEnumNames.contains(field.type.baseName)) {
            indent.writeln(
                'val ${field.name} = $fieldType.ofRaw($listValue as Int)!!');
          } else if (isInt) {
            indent.write('val ${field.name} = $listValue');
            indent.addln('.let { ${_cast(listValue, type: field.type)} }');
          } else {
            indent.writeln(
                'val ${field.name} = ${_cast(listValue, type: field.type)}');
          }
        }
      });

      indent.write('return $className(');
      for (final NamedType field in getFieldsInSerializationOrder(klass)) {
        final String comma =
            getFieldsInSerializationOrder(klass).last == field ? '' : ', ';
        indent.add('${field.name}$comma');
      }
      indent.addln(')');
    });
    // });
  }

  void _writeClassField(Indent indent, NamedType field) {
    addDocumentationComments(
        indent, field.documentationComments, _docCommentSpec);
    indent.write(
        'var ${field.name}: ${_nullsafeKotlinTypeForDartType(field.type)}');
    final String defaultNil = field.type.isNullable ? ' = null' : '';
    indent.add(defaultNil);
  }

  @override
  void writeApis(
    KotlinOptions generatorOptions,
    Root root,
    Indent indent,
  ) {
    if (writeModelsOnly) {
      print('仅写入models apis');
      for (final Api api in root.apis) {
        if (api.location == ApiLocation.host) {
          _writeHostApi(generatorOptions, root, indent, api, true);
        }
      }
      return;
    }
    print('写入所有apis');
    if (root.apis.any((Api api) =>
        api.location == ApiLocation.host &&
        api.methods.any((Method it) => it.isAsynchronous))) {
      indent.newln();
    }
    for (final Api api in root.apis) {
      if (api.location == ApiLocation.host) {
        _writeHostApi(generatorOptions, root, indent, api, false);
        writeHostApi(generatorOptions, root, indent, api);
      } else if (api.location == ApiLocation.flutter) {
        writeFlutterApi(generatorOptions, root, indent, api);
      }
    }
    // super.writeApis(generatorOptions, root, indent);
  }

  /// Writes the code for a flutter [Api], [api].
  /// Example:
  /// class Foo(private val binaryMessenger: BinaryMessenger) {
  ///   fun add(x: Int, y: Int, callback: (Int?) -> Unit) {...}
  /// }
  @override
  void writeFlutterApi(
    KotlinOptions generatorOptions,
    Root root,
    Indent indent,
    Api api,
  ) {
    assert(api.location == ApiLocation.flutter);
    final bool isCustomCodec = getCodecClasses(api, root).isNotEmpty;
    if (isCustomCodec) {
      _writeCodec(indent, api, root);
    }

    const List<String> generatedMessages = <String>[
      // ' Generated class from Pigeon that represents Flutter messages that can be called from Kotlin.'
    ];
    addDocumentationComments(
        indent, api.documentationComments, _docCommentSpec);

    final String apiName = api.name;
    indent.writeln('@Suppress("UNCHECKED_CAST")');
    indent
        .write('class $apiName(private val binaryMessenger: BinaryMessenger) ');
    indent.addScoped('{', '}', () {
      indent.write('companion object ');
      indent.addScoped('{', '}', () {
        indent.writeln('/** The codec used by $apiName. */');
        indent.write('val codec: MessageCodec<Any?> by lazy ');
        indent.addScoped('{', '}', () {
          if (isCustomCodec) {
            indent.writeln(_getCodecName(api));
          } else {
            indent.writeln('StandardMessageCodec()');
          }
        });
      });

      for (final Method func in api.methods) {
        final String channelName = makeChannelName(api, func);
        final String returnType = func.returnType.isVoid
            ? ''
            : _nullsafeKotlinTypeForDartType(func.returnType);
        String sendArgument;

        addDocumentationComments(
            indent, func.documentationComments, _docCommentSpec);
        if (func.arguments.isEmpty) {
          indent.write('fun ${func.name}(callback: ($returnType) -> Unit) ');
          sendArgument = 'null';
        } else {
          final Iterable<String> argTypes = func.arguments
              .map((NamedType e) => _nullsafeKotlinTypeForDartType(e.type));
          final Iterable<String> argNames =
              indexMap(func.arguments, _getSafeArgumentName);
          sendArgument = 'listOf(${argNames.join(', ')})';
          final String argsSignature = map2(argTypes, argNames,
              (String type, String name) => '$name: $type').join(', ');
          if (func.returnType.isVoid) {
            indent.write(
                'fun ${func.name}($argsSignature, callback: () -> Unit) ');
          } else {
            indent.write(
                'fun ${func.name}($argsSignature, callback: ($returnType) -> Unit) ');
          }
        }
        indent.addScoped('{', '}', () {
          const String channel = 'channel';
          indent.writeln(
              'val $channel = BasicMessageChannel<Any?>(binaryMessenger, "$channelName", codec)');
          indent.write('$channel.send($sendArgument) ');
          if (func.returnType.isVoid) {
            indent.addScoped('{', '}', () {
              indent.writeln('callback()');
            });
          } else {
            indent.addScoped('{', '}', () {
              indent.writeln(
                  'val result = ${_cast('it', type: func.returnType)}');
              indent.writeln('callback(result)');
            });
          }
        });
      }
    });
  }

  /// 把 interface 写进 model 里面
  void _writeHostApi(KotlinOptions generatorOptions, Root root, Indent indent,
      Api api, bool writeModelsOnly) {
    assert(api.location == ApiLocation.host);
    if (!writeModelsOnly) {
      final bool isCustomCodec = getCodecClasses(api, root).isNotEmpty;
      if (isCustomCodec) {
        _writeCodec(indent, api, root);
      }
      return;
    }
    final String apiName = api.name;
    const List<String> generatedMessages = <String>[
      ' Generated interface from Pigeon that represents a handler of messages from Flutter.'
    ];
    addDocumentationComments(indent, api.documentationComments, _docCommentSpec,
        generatorComments: generatedMessages);
    indent.write('interface $apiName ');
    indent.addScoped('{', writeModelsOnly ? '}' : '', () {
      for (final Method method in api.methods) {
        if (method.ignored) {
          continue;
        }
        final List<String> argSignature = <String>[];
        if (method.arguments.isNotEmpty) {
          final Iterable<String> argTypes = method.arguments
              .where((NamedType element) => !element.ignored)
              .map((NamedType e) => _nullsafeKotlinTypeForDartType(e.type));
          final Iterable<String> argNames =
              method.arguments.map((NamedType e) => e.name);
          argSignature.addAll(
              map2(argTypes, argNames, (String argType, String argName) {
            return '$argName: $argType';
          }));
        }

        final String returnType = method.returnType.isVoid
            ? ''
            : _nullsafeKotlinTypeForDartType(method.returnType);

        final String resultType =
            method.returnType.isVoid ? 'Unit' : returnType;
        addDocumentationComments(
            indent, method.documentationComments, _docCommentSpec);

        if (root.supportKmm && method.kmmObjcMethodName.isNotEmpty) {
          indent.writeln('@ObjCName("${method.kmmObjcMethodName}")');
        }
        if (method.isAsynchronous) {
          // if (writeModelsOnly) {
          //   // 只编译 models 时，将 Result<$resultType> 改为 CommonResult， 这样在 KMM 中转换到 OC 时，不会出现类型为 id
          //   argSignature.add('callback: (CommonResult) -> Unit');
          // } else {
          // 在 flutter 中使用时保留其原有类型
          argSignature.add('callback: (Result<$resultType>) -> Unit');
          // }
          indent.writeln('fun ${method.name}(${argSignature.join(', ')})');
        } else if (method.returnType.isVoid) {
          indent.writeln('fun ${method.name}(${argSignature.join(', ')})');
        } else {
          indent.writeln(
              'fun ${method.name}(${argSignature.join(', ')}): $returnType');
        }
      }
      indent.newln();
      indent.write('companion object ');
      indent.addScoped('{', '}', () {
        indent.newln();
      });
      indent.newln();
    });
  }

  /// Write the kotlin code that represents a host [Api], [api].
  /// Example:
  /// interface Foo {
  ///   Int add(x: Int, y: Int);
  ///   companion object {
  ///     fun setUp(binaryMessenger: BinaryMessenger, api: Api) {...}
  ///   }
  /// }
  ///
  @override
  void writeHostApi(
    KotlinOptions generatorOptions,
    Root root,
    Indent indent,
    Api api,
  ) {
    assert(api.location == ApiLocation.host);

    final String apiName = api.name;

    final bool isCustomCodec = getCodecClasses(api, root).isNotEmpty;

    // indent.write('companion object ');
    // indent.addScoped('{', '}', () {
    indent.writeln('/** The codec used by $apiName. */');
    indent.write('val $apiName.Companion.codec: MessageCodec<Any?> by lazy ');
    indent.addScoped('{', '}', () {
      if (isCustomCodec) {
        indent.writeln(_getCodecName(api));
      } else {
        indent.writeln('StandardMessageCodec()');
      }
    });
    indent.writeln(
        '/** Sets up an instance of `$apiName` to handle messages through the `binaryMessenger`. */');
    indent.writeln('@Suppress("UNCHECKED_CAST")');
    indent.write(
        'fun $apiName.Companion.setUp(binaryMessenger: BinaryMessenger, api: $apiName?) ');
    indent.addScoped('{', '}', () {
      for (final Method method in api.methods) {
        indent.write('run ');
        indent.addScoped('{', '}', () {
          String? taskQueue;
          if (method.taskQueueType != TaskQueueType.serial) {
            taskQueue = 'taskQueue';
            indent.writeln(
                'val $taskQueue = binaryMessenger.makeBackgroundTaskQueue()');
          }

          final String channelName = makeChannelName(api, method);

          indent.write(
              'val channel = BasicMessageChannel<Any?>(binaryMessenger, "$channelName", codec');

          if (taskQueue != null) {
            indent.addln(', $taskQueue)');
          } else {
            indent.addln(')');
          }

          indent.write('if (api != null) ');
          indent.addScoped('{', '}', () {
            final String messageVarName =
                method.arguments.isNotEmpty ? 'message' : '_';

            indent.write('channel.setMessageHandler ');
            indent.addScoped('{ $messageVarName, reply ->', '}', () {
              final List<String> methodArguments = <String>[];
              if (method.arguments.isNotEmpty) {
                indent.writeln('val args = message as List<Any?>');
                enumerate(method.arguments, (int index, NamedType arg) {
                  final String argName = _getSafeArgumentName(index, arg);
                  final String argIndex = 'args[$index]';
                  indent.writeln(
                      'val $argName = ${_castForceUnwrap(argIndex, arg.type, root)}');
                  methodArguments.add(argName);
                });
              }
              final String call =
                  'api.${method.name}(${methodArguments.join(', ')})';

              if (method.isAsynchronous) {
                indent.write('$call ');
                final String resultType = method.returnType.isVoid
                    ? 'Unit'
                    : _nullsafeKotlinTypeForDartType(method.returnType);
                indent.addScoped('{ result: Result<$resultType> ->', '}', () {
                  indent.writeln('val error = result.exceptionOrNull()');
                  indent.writeScoped('if (error != null) {', '}', () {
                    indent.writeln('reply.reply(wrapError(error))');
                  }, addTrailingNewline: false);
                  indent.addScoped(' else {', '}', () {
                    if (method.returnType.isVoid) {
                      indent.writeln('reply.reply(wrapResult(null))');
                    } else {
                      indent.writeln('val data = result.getOrNull()');
                      indent.writeln('reply.reply(wrapResult(data))');
                    }
                  });
                });
              } else {
                indent.writeln('var wrapped: List<Any?>');
                indent.write('try ');
                indent.addScoped('{', '}', () {
                  if (method.returnType.isVoid) {
                    indent.writeln(call);
                    indent.writeln('wrapped = listOf<Any?>(null)');
                  } else {
                    indent.writeln('wrapped = listOf<Any?>($call)');
                  }
                }, addTrailingNewline: false);
                indent.add(' catch (exception: Throwable) ');
                indent.addScoped('{', '}', () {
                  indent.writeln('wrapped = wrapError(exception)');
                });
                indent.writeln('reply.reply(wrapped)');
              }
            });
          }, addTrailingNewline: false);
          indent.addScoped(' else {', '}', () {
            indent.writeln('channel.setMessageHandler(null)');
          });
        });
      }
    });
    // indent.add('}');
    // });
  }

  /// Writes the codec class that will be used by [api].
  /// Example:
  /// private static class FooCodec extends StandardMessageCodec {...}
  void _writeCodec(Indent indent, Api api, Root root) {
    assert(getCodecClasses(api, root).isNotEmpty);
    final Iterable<EnumeratedClass> codecClasses = getCodecClasses(api, root);
    final String codecName = _getCodecName(api);
    indent.writeln('@Suppress("UNCHECKED_CAST")');
    indent.write('private object $codecName : StandardMessageCodec() ');
    indent.addScoped('{', '}', () {
      indent.write(
          'override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? ');
      indent.addScoped('{', '}', () {
        indent.write('return when (type) ');
        indent.addScoped('{', '}', () {
          for (final EnumeratedClass customClass in codecClasses) {
            indent.write('${customClass.enumeration}.toByte() -> ');
            indent.addScoped('{', '}', () {
              indent.write('return (readValue(buffer) as? List<Any?>)?.let ');
              indent.addScoped('{', '}', () {
                indent.writeln('${customClass.name}.fromList(it)');
              });
            });
          }
          indent.writeln('else -> super.readValueOfType(type, buffer)');
        });
      });

      indent.write(
          'override fun writeValue(stream: ByteArrayOutputStream, value: Any?) ');
      indent.writeScoped('{', '}', () {
        indent.write('when (value) ');
        indent.addScoped('{', '}', () {
          for (final EnumeratedClass customClass in codecClasses) {
            indent.write('is ${customClass.name} -> ');
            indent.addScoped('{', '}', () {
              indent.writeln('stream.write(${customClass.enumeration})');
              indent.writeln('writeValue(stream, value.toList())');
            });
          }
          indent.writeln('else -> super.writeValue(stream, value)');
        });
      });
    });
    indent.newln();
  }

  void _writeWrapResult(Indent indent) {
    indent.newln();
    indent.write('private fun wrapResult(result: Any?): List<Any?> ');
    indent.addScoped('{', '}', () {
      indent.writeln('return listOf(result)');
    });
  }

  void _writeWrapError(KotlinOptions generatorOptions, Indent indent) {
    indent.newln();
    indent.write('private fun wrapError(exception: Throwable): List<Any?> ');
    indent.addScoped('{', '}', () {
      indent.write(
          'if (exception is ${generatorOptions.errorClassName ?? "FlutterError"}) ');
      indent.addScoped('{', '}', () {
        indent.write('return ');
        indent.addScoped('listOf(', ')', () {
          indent.writeln('exception.code,');
          indent.writeln('exception.message,');
          indent.writeln('exception.details');
        });
      }, addTrailingNewline: false);
      indent.addScoped(' else {', '}', () {
        indent.write('return ');
        indent.addScoped('listOf(', ')', () {
          indent.writeln('exception.javaClass.simpleName,');
          indent.writeln('exception.toString(),');
          indent.writeln(
              '"Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)');
        });
      });
    });
  }

  void _writeErrorClass(KotlinOptions generatorOptions, Indent indent) {
    indent.newln();
    indent.writeln('/**');
    indent.writeln(
        ' * Error class for passing custom error details to Flutter via a thrown PlatformException.');
    indent.writeln(' * @property code The error code.');
    indent.writeln(' * @property message The error message.');
    indent.writeln(
        ' * @property details The error details. Must be a datatype supported by the api codec.');
    indent.writeln(' */');
    indent.write('class ${generatorOptions.errorClassName ?? "FlutterError"} ');
    indent.addScoped('(', ')', () {
      indent.writeln('val code: String,');
      indent.writeln('override val message: String? = null,');
      indent.writeln('val details: Any? = null');
    }, addTrailingNewline: false);
    indent.addln(' : Throwable()');
  }

  @override
  void writeGeneralUtilities(
      KotlinOptions generatorOptions, Root root, Indent indent) {
    if (writeModelsOnly) {
      print('只写入models');
    } else {
      _writeWrapResult(indent);
      _writeWrapError(generatorOptions, indent);
      _writeErrorClass(generatorOptions, indent);
    }
  }
}

HostDatatype _getHostDatatype(Root root, NamedType field) {
  return getFieldHostDatatype(field, root.classes, root.enums,
      (TypeDeclaration x) => _kotlinTypeForBuiltinDartType(x));
}

/// Calculates the name of the codec that will be generated for [api].
String _getCodecName(Api api) => '${api.name}Codec';

String _getArgumentName(int count, NamedType argument) =>
    argument.name.isEmpty ? 'arg$count' : argument.name;

/// Returns an argument name that can be used in a context where it is possible to collide.
String _getSafeArgumentName(int count, NamedType argument) =>
    '${_getArgumentName(count, argument)}Arg';

String _castForceUnwrap(String value, TypeDeclaration type, Root root) {
  if (isEnum(root, type)) {
    final String forceUnwrap = type.isNullable ? '' : '!!';
    final String nullableConditionPrefix =
        type.isNullable ? '$value == null ? null : ' : '';
    return '$nullableConditionPrefix${_kotlinTypeForDartType(type)}.ofRaw($value as Int)$forceUnwrap';
  } else {
    // The StandardMessageCodec can give us [Integer, Long] for
    // a Dart 'int'.  To keep things simple we just use 64bit
    // longs in Pigeon with Kotlin.
    if (type.baseName == 'int') {
      return '$value.let { ${_cast(value, type: type)} }';
    } else {
      return _cast(value, type: type);
    }
  }
}

/// Converts a [List] of [TypeDeclaration]s to a comma separated [String] to be
/// used in Kotlin code.
String _flattenTypeArguments(List<TypeDeclaration> args) {
  return args.map(_kotlinTypeForDartType).join(', ');
}

String _kotlinTypeForBuiltinGenericDartType(TypeDeclaration type) {
  if (type.typeArguments.isEmpty) {
    switch (type.baseName) {
      case 'List':
        return 'List<Any?>';
      case 'Map':
        return 'Map<Any, Any?>';
      default:
        return 'Any';
    }
  } else {
    switch (type.baseName) {
      case 'List':
        return 'List<${_nullsafeKotlinTypeForDartType(type.typeArguments.first)}>';
      case 'Map':
        return 'Map<${_nullsafeKotlinTypeForDartType(type.typeArguments.first)}, ${_nullsafeKotlinTypeForDartType(type.typeArguments.last)}>';
      default:
        return '${type.baseName}<${_flattenTypeArguments(type.typeArguments)}>';
    }
  }
}

String? _kotlinTypeForBuiltinDartType(TypeDeclaration type) {
  final Map<String, String> kotlinTypeForDartTypeMap = <String, String>{
    'void': 'Void',
    'bool': 'Boolean',
    'String': 'String',
    'int': 'Long',
    'double': 'Double',
    'Uint8List': 'ByteArray',
    'Int32List': 'IntArray',
    'Int64List': 'LongArray',
    'Float32List': 'FloatArray',
    'Float64List': 'DoubleArray',
    'Object': 'Any',
  };
  // if (writeModelsOnly) {
  //   kotlinTypeForDartTypeMap = <String, String>{
  //     'void': 'Void',
  //     'bool': 'Boolean',
  //     'String': 'String',
  //     'int': 'Int',
  //     'long': 'Long',
  //     'float': 'Float',
  //     'double': 'Double',
  //     'Uint8List': 'ByteArray',
  //     'Int32List': 'IntArray',
  //     'Int64List': 'LongArray',
  //     'Float32List': 'FloatArray',
  //     'Float64List': 'DoubleArray',
  //     'Object': 'Any',
  //   };
  // }
  if (kotlinTypeForDartTypeMap.containsKey(type.baseName)) {
    return kotlinTypeForDartTypeMap[type.baseName];
  } else if (type.baseName == 'List' || type.baseName == 'Map') {
    return _kotlinTypeForBuiltinGenericDartType(type);
  } else {
    return null;
  }
}

String _kotlinTypeForDartType(TypeDeclaration type) {
  return _kotlinTypeForBuiltinDartType(type) ?? type.baseName;
}

String _nullsafeKotlinTypeForDartType(TypeDeclaration type) {
  final String nullSafe = type.isNullable ? '?' : '';
  return '${_kotlinTypeForDartType(type)}$nullSafe';
}

/// Returns an expression to cast [variable] to [kotlinType].
String _cast(String variable, {required TypeDeclaration type}) {
  // Special-case Any, since no-op casts cause warnings.
  final String typeString = _kotlinTypeForDartType(type);
  if (type.isNullable && typeString == 'Any') {
    return variable;
  }
  if (typeString == 'Int' || typeString == 'Long') {
    return _castInt(type.isNullable);
  }
  return '$variable as ${_nullsafeKotlinTypeForDartType(type)}';
}

String _castInt(bool isNullable) {
  final String nullability = isNullable ? '?' : '';
  return 'if (it is Int) it.toLong() else it as Long$nullability';
}
