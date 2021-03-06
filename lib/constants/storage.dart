import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/db.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String content = await file.readAsString();
      return content;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString('$data');
  }
}
