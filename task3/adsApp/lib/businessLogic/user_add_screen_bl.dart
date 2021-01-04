import 'package:add_store/utility/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:add_store/utility/local_storage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sql.dart';

class CurrentUserAddScreenBL {
  CurrentUserAddScreenBL(Map<String, dynamic> userData,
      List<Map<String, dynamic>> currentUserAdds) {
    this.userData = userData;
    this.currentUserAdds = currentUserAdds;
  }

  Map<String, dynamic> userData;
  List<Map<String, dynamic>> currentUserAdds;

  Future deleteAdd(int addID) async {
    Database dataBase = await DatabaseHelper.instance.database;
    await dataBase.rawDelete('DELETE FROM Adds WHERE ID = ?', [addID]);
    await updateCurrentUserAddList();
  }

  Future updateAdd(Map<String, dynamic> updatedAdd) async {
    Database dataBase = await DatabaseHelper.instance.database;
    await dataBase.update("Adds", updatedAdd,
        where: 'ID = ?', whereArgs: [updatedAdd["ID"]]);
    await updateCurrentUserAddList();
  }

  Future insertNewAdd(Map<String, dynamic> newAdd) async {
    Database dataBase = await DatabaseHelper.instance.database;
    await dataBase.insert("Adds", newAdd,
        conflictAlgorithm: ConflictAlgorithm.replace);
    await updateCurrentUserAddList();
  }

  Future updateCurrentUserAddList() async {
    Database dataBase = await DatabaseHelper.instance.database;
    currentUserAdds = await dataBase
        .rawQuery("SELECT * FROM Adds WHERE creatorID = ?", [userData["ID"]]);
  }
}
