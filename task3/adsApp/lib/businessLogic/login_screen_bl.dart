import 'package:add_store/utility/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:add_store/utility/local_storage.dart';
import 'dart:convert';

class LoginScreenBL {
  String userName;
  String password;
  bool rememberMe = false;
  Map<String, dynamic> userData;

  Future<int> loginUser() async {
    Database dataBase = await DatabaseHelper.instance.database;
    //checking if user exists
    var userCreds = await dataBase
        .rawQuery('SELECT * FROM Users WHERE userName=?', [userName]);
    if (userCreds.isEmpty) {
      //registering user
      await dataBase.rawQuery(
          'INSERT INTO Users (userName,password) VALUES(?, ?);',
          [userName, password]);
      return 1; // returns 1 for registered user
    } else if (userCreds.isNotEmpty) {
      //login in user
      if (userCreds.first["password"] == password) {
        userData = userCreds.first;
        _handlingRememberMe();
        return 0; //0 for okay login
      } else {
        return 2; //2 for incorrect password
      }
    }
    return 3; //3 for idk error
  }

  void _handlingRememberMe() async{
    if (rememberMe == false) {
      await LocalStorage.init();
      LocalStorage.prefs.setBool("rememberUser", false);
    } else {
      var userDataJson = jsonEncode(userData);
      await LocalStorage.init();
      LocalStorage.prefs.setBool("rememberUser", true);
      LocalStorage.prefs.setString("userJson", userDataJson);
    }
  }
}
