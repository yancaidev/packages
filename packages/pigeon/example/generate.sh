flutter pub run pigeon \
  --input example/hello.dart \
  --dart_out example/dist/pigeon.dart \
  --objc_header_out example/dist/pigeon.h \
  --objc_source_out example/dist/pigeon.m \
  --experimental_swift_out example/dist/Pigeon.swift \
  --experimental_kotlin_out example/dist/Pigeon.kt \
  --experimental_kotlin_package "dev.flutter.pigeon" \
  --java_out example/dist/Pigeon.java \
  --java_package "dev.flutter.pigeon"
