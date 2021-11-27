import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:invoice_register/Database/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';



class DatabaseHandler{

  static final DatabaseName = "invoices";
  static final tableName = "invoiceRegister";
  static final column1 = "id";
  static final column2 = 'invoiceNumber';
  static final column3 = 'type';
  static final column4 = 'storeName';
  static final column5 = 'subtotal';
  static final column6 = 'date';
  static final column7 = 'concept';

  static final column8 = 'dayR';
  static final column9 = 'monthR';
  static final column10 = 'yearR';

  Future<Database> initializeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, '$DatabaseName.db'),
      onCreate: (database, version) async{
        await database.execute(
          '''
          CREATE TABLE $tableName ($column1 INTEGER PRIMARY KEY AUTOINCREMENT, 
          $column2 TEXT NOT NULL, $column3 TEXT, $column4 TEXT, 
          $column5 TEXT NOT NULL, $column6 TEXT NOT NULL, $column7 TEXT NOT NULL,
          $column8 INTEGER, $column9 INTEGER, $column10 INTEGER
          )
          '''
        );
      },
      version: 1,
    );
  }


  Future<int> insertUser(List<user> users) async{
    int result = 0;
    final Database db = await initializeDB();
    for(var user in users){
      result = await db.insert('$tableName', user.toMap());
    }
    return result;
  }

/*
  Future<List<user>> retrieveUsersCondition(String condition, int year, int month) async{
    final Database db = await initializeDB();
    final List<Map<String, Object>> queryResult = await db.query('$tableName',
              where: "$column7 = ? AND $column10 = ? AND $column9 = ?", whereArgs: [condition, year, month]);
    return queryResult.map((e) => user.fromMap(e)).toList();
  }
  */

    Future getAllData() async{
      
      final Database db = await initializeDB();
      final res = await db.rawQuery("SELECT * FROM $tableName");
      
      return res;
  }




  Future<List<user>> retrieveUsers(int year, int month) async{
    final Database db = await initializeDB();
    final List<Map<String, Object>> queryResult = await db.query('$tableName',
              where: "$column10 = ? AND $column9 = ?", whereArgs: [year, month]);
    return queryResult.map((e) => user.fromMap(e)).toList();
  }


  Future<void> deleteUser(int id) async{
    final db = await initializeDB();
    await db.delete(
      '$tableName',
      where: 'id = ?',
      whereArgs: [id]
    );
  }



}










