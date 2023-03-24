#!/bin/bash
# 获取 dist 目录绝对路径
DIST_DIR="$(cd "$(dirname "$0")" && pwd)/dist"

# 删除 dist 目录下的所有文件
rm -rf "${DIST_DIR}/*"

echo "执行指令时，可以传入参数，如 ./generate.sh true。 true 表示仅输出数据模型，false 表示输出flutter 与原生的通信代码。"

# 当用户点击了 enter 按键时，才继续执行
read -p "是否继续？(y/n)" -n 1 -r

# 获取用户输入了 y 或者 Y 时，才继续执行
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo
  echo "继续执行"
else
  echo
  echo "退出执行"
  exit 1
fi

# 如果是 flutter 生成 pigeon 文件，否则 生成 pigeon_model 文件。
targetname="pigeon"
if [ "$1" = "true" ]; then
  targetname="pigeon_model"
fi

echo "Objective-C 导出文件名： ${targetname}"

flutter pub run pigeon \
  --input example/hello.dart \
  --dart_out example/dist/pigeon.dart \
  --objc_header_out "example/dist/${targetname}.h" \
  --objc_source_out "example/dist/${targetname}.m" \
  --experimental_kotlin_out example/dist/Pigeon.kt \
  --experimental_kotlin_package "dev.flutter.pigeon" \
  --write_models_only $1