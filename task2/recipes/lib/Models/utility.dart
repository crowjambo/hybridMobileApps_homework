import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'constants.dart';

class JsonHelper {
  List<dynamic> decodedJsonArray;

  Future createJsonFile() async{
    File commentFile = await _localFile(kCommentFilename);

    if(commentFile.readAsStringSync().length!=0){return;}
    else{
      commentFile.createSync();
      String jsonString = await rootBundle.loadString(kCommentFilenameAssets);
      commentFile.writeAsStringSync(jsonString);
      print(commentFile.readAsStringSync());
    }
  }

  Future<List<dynamic>> getJsonArray() async{
    File commentFile = await _localFile(kCommentFilename);
    String jsonString = commentFile.readAsStringSync();

    decodedJsonArray = jsonDecode(jsonString)['array'];
    return decodedJsonArray;
  }

  Future<List<dynamic>> getRecipesJson() async{
    String jsonString = await rootBundle.loadString(kRecipeJson);

    decodedJsonArray = jsonDecode(jsonString)['array'];
    return decodedJsonArray;
  }

  String returnJsonString(var jsonMap) {

    Map<String, dynamic> placeholderMap = {'array':jsonMap};
    String jsonString = jsonEncode(placeholderMap);

    return jsonString;
  }

  void writeJsonStringToFile(String jsonString) async{

    final file = await _localFile(kCommentFilename);
    file.writeAsStringSync(jsonString);
    print(file.existsSync());
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

}