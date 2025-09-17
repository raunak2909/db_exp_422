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

  Future<Database> initDB() async {
    mDb ??= await openDB();
    return mDb!;
  }

  Future<Database> openDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    print("appDocDir: ${appDocDir.path}");

    String dbPath = join(appDocDir.path, "notesDB.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        /// tables creation

        db.execute(
          "create table note ( n_id integer primary key autoincrement, n_title text, n_desc text, n_created_at text )",
        );
      },
    );
  }

  ///insert
}
