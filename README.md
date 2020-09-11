# JSON to Dart

读取json文件或json目录中的文件，生成dart类到指定目录

根据json生成dart类的代码来源：https://github.com/javiercbk/json_to_dart
在原来的基础上改成了库，添加了命令行运行，读取json文件，生成dart类

## :book: 指南

#### 1. 安装

加入以下设置到 `pubspec.yaml`
```yaml
dev_dependencies:
  json_to_dart:
    git:
      url: https://github.com/fromgz/json_to_dart.git
```

设置完成后，在项目根目录下创建源目录，如json,把需要生成dart类的json文件放入目录中，指定放置dart类的目标目录，如lib/model，运行以下命令
```
flutter pub get
flutter pub run json_to_dart -p json -o lib/model
```