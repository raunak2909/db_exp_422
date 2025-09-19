import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  ///singleton pattern
  ///private constructor
  DBHelper._();

  /*static DBHelper getInstance(){
    return DBHelper._();
  }*/
  static final DBHelper instance = DBHelper._();

  Database? mDb;
  static const String noteTable = "note";
  static const String columnNoteId = "n_id";
  static const String columnNoteTitle = "n_title";
  static const String columnNoteDesc = "n_desc";
  static const String columnNoteCreatedAt = "n_created_at";

  Future<Database> initDB() async {
    mDb ??= await openDB();
    return mDb!;
  }

  Future<Database> openDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
   // print("appDocDir: ${appDocDir.path}");

    //data/data/com.example.db_exp_422/app_flutter/notesDB.db
    String dbPath = join(appDocDir.path, "notesDB.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        /// tables creation

        db.execute(
          "create table $noteTable ( $columnNoteId integer primary key autoincrement, $columnNoteTitle text, $columnNoteDesc text, $columnNoteCreatedAt text )",
        );
      },
    );
  }

  /// insert
  Future<bool> insertNote({required String title, required String desc}) async{

    var db = await initDB();

    int rowsEffected = await db.insert(noteTable, {
      columnNoteTitle : title,
      columnNoteDesc : desc,
      columnNoteCreatedAt : DateTime.now().millisecondsSinceEpoch,
    });

    return rowsEffected>0;
  }
  /// fetch
  Future<List<Map<String, dynamic>>> fetchAllNotes() async{
    var db = await initDB();
    
    return await db.query(noteTable);
  }
  /// update
  /// delete
}
