import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dpPath = await sql.getDatabasesPath();
    // IF WE COULD NOT FIND THE FILE oncreat WILL DO THAT FOR US
    return sql.openDatabase(path.join(dpPath, "places.db"),
        onCreate: (db, version) {
      return db.execute(
          'CREAT TABLE user_places(id TEXT KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
