# JSON to Dart

Given a JSON string, this library will generate all the necessary Dart classes to parse and generate JSON.

This library is designed to generate Flutter friendly model classes following the [flutter's doc recommendation](https://flutter.io/json/#serializing-json-manually-using-dartconvert).

来源：https://github.com/javiercbk/json_to_dart，添加了命令行运行生成文件

## Install

dev_dependencies:
  json_to_dart: ^0.0.1

  
flutter pub get
flutter pub run json_to_dart -p json -o lib/model