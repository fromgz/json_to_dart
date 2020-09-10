import 'dart:io';
import 'package:args/args.dart';
import 'package:json_to_dart/json_to_dart.dart';
import 'package:path/path.dart';

ArgResults argResults;
Future<void> main(List<String> args) async {
  // 创建ArgParser的实例，同时指定需要输入的参数
  final ArgParser parser = ArgParser()
    ..addOption('path', abbr: 'p', defaultsTo: 'json', help: 'json file path or json dir path')
    ..addOption('output', abbr: 'o', defaultsTo: 'lib/model', help: 'output dir path',);

  argResults = parser.parse(args);
  try{
    if (FileSystemEntity.isFileSync(argResults["output"])){
      stderr.writeln("argument output must be a directory");
      exit(2);
    }
    var outputDir = new Directory(argResults["output"]);
    bool exist = await outputDir.exists();
    if (!exist){
      outputDir.createSync();
    }
    
    String src = argResults["path"];
    if (FileSystemEntity.isDirectorySync(src)){
      walk(src, createModel);
    }else if (FileSystemEntity.isFileSync(src)){
      await createModel(src);
    }else{
      stderr.writeln("argument path must be a directory path or a file path");
      exit(2);
    }
    stdout.writeln("All generated!");
  }catch(e){
    stderr.writeln(e);
    exit(2);
  }
}

Future<void> walk(String dirPath, Function func) async{
  var directory = new Directory(dirPath);
  List<FileSystemEntity> files = directory.listSync();
  for(var f in files){
    var isFile = FileSystemEntity.isFileSync(f.path);
    if(isFile){
      if (f.path.endsWith(".json")){
        if (func!=null) await func(f.path);
      }
    }else{
      walk(f.path, func);
    }
  }
}

Future<void> createModel(String path) async{
  File file = new File(path);
  String filename = basename(file.path);
  String name = filename.split(".")[0];
  String className = under2camel(name);
  String clsFilePath = normalize(join(argResults["output"], "$name.dart"));

  stdout.writeln("generate model $path => $clsFilePath");

  final classGenerator = new ModelGenerator(className);
  final jsonRawData = file.readAsStringSync();
  DartCode dartCode = classGenerator.generateDartClasses(jsonRawData);
  File clsFile = File(clsFilePath);
  clsFile.writeAsStringSync(dartCode.code);
}

String under2camel(String s){
  String separator = "_";
  String under = "";
  List<String> sList = s.split(separator);
  for(int i=0; i<sList.length; i++)
  {
    String w = "${sList[i].substring(0,1).toUpperCase()}${sList[i].substring(1)}";
    under +=w;
  }
  return under;
}