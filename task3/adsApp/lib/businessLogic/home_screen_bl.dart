import '../utility/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../utility/local_storage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class HomeScreenBL {
  HomeScreenBL(Map<String, dynamic> userData) {
    this.userData = userData;
    init();
  }

  Map<String, dynamic> userData;
  List<Map<String, dynamic>> shownAdds;
  List<Map<String, dynamic>> allAdds;
  List<Map<String, dynamic>> currentUserAdds = List<Map<String, dynamic>>();
  List<Map<String, dynamic>> users;

  List<Map<String, dynamic>> loadCurrentUserAdds() {
    var currentUserID = userData["ID"];
    currentUserAdds.clear();
    currentUserAdds = allAdds
        .where((element) => element["creatorID"] == currentUserID)
        .toList();

    return currentUserAdds;
  }

  void init() async {
    //loading user list
    Database dataBase = await DatabaseHelper.instance.database;
    users = await dataBase.rawQuery('SELECT * FROM Users');
    print(users.toString());

    //loading all adds
    allAdds = await dataBase.rawQuery('SELECT * FROM Adds');
    print(allAdds.toString());
  }

  Future<List<Map<String, dynamic>>> loadAllAdds() async {
    Database dataBase = await DatabaseHelper.instance.database;
    allAdds = await dataBase.rawQuery('SELECT * FROM Adds');
    shownAdds = allAdds;
    return shownAdds;
  }
}
