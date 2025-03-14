import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart'; // ファイルパスを操作するためのユーティリティ
// import 'package:path_provider/path_provider.dart'; // アプリが使用できるディレクトリ（パス）を取得するためのツール

class DatabaseHelper {
  // static:クラス全体で溶融されるインスタンス変数
  // _privateConstructor()により, 外部から新たにインスタンスを作るのを防ぐ。
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!; // 初期化済みならそのまま返す
    _database = await _initDatabase(); // 初期化されていなければ非同期で初期化
    return _database!; // 初期化後のインスタンスを返す
  }

  // データベース初期作成
  Future<Database> _initDatabase() async {
    // getDatabasesPath:SQLiteデータベースが保存されるディレクトリのパスを取得する非同期関数
    // openDatabase:指定されたファイルパスにSQLiteデータベースを開く、または新規作成する関数
    String path = join(await getDatabasesPath(), 'gymlog.db');
    return await openDatabase(
      path,
      version: 1,
      // onCreate:データベースが初めて作成されたときに呼び出されるコールバック関数。
      onCreate: (db, version) async {
        // テーブル名: training_menu
        await db.execute('''
        CREATE TABLE training_menu (
          training_id INTEGER PRIMARY KEY AUTOINCREMENT,
          training_name TEXT NOT NULL UNIQUE,
          seat_height INTEGER,
          arm_position INTEGER
        )
      ''');

        // テーブル2: record
        await db.execute('''
        CREATE TABLE record (
          record_id INTEGER PRIMARY KEY AUTOINCREMENT,
          training_id INTEGER NOT NULL,
          set_number INTEGER NOT NULL,
          weight INTEGER NOT NULL,
          count INTEGER,
          minutes INTEGER,
          date_time TEXT NOT NULL,
          FOREIGN KEY (training_id) REFERENCES training_menu(training_id)
        )
      ''');
      },
    );
  }

  /* テーブルのデータを取得・読み込み */
  // トレーニングメニューテーブルを取得
  Future<List<Map<String, dynamic>>> getMenu() async {
    final db = await database;
    return await db.query('training_menu');
  }

  // 特定のメニューのデータだけ取得
  Future<Map<String, dynamic>?> getSelectMenu(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'training_menu',
      where: 'training_id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // レコードテーブル
  Future<List<Map<String, dynamic>>> getRecord() async {
    final db = await database;
    return await db.query('record');
  }

  // データの挿入
  // トレーニングメニューにデータを追加するメソッド
  Future<int> insertMenu(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('training_menu', row);
  }

  // レコードにデータを追加するメソッド
  Future<int> insertRecord(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('record', row);
  }

  // 特定のレコードを削除するメソッド
  Future<int> deleteMenu(int id) async {
    final db = await database;
    return await db
        .delete('training_menu', where: 'training_id = ?', whereArgs: [id]);
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete('record', where: 'record_id = ?', whereArgs: [id]);
  }

  // トレーニングメニューのデータを更新するメソッド
  Future<int> updateMenu(int id, Map<String, dynamic> row) async {
    final db = await database;
    return await db.update(
      'training_menu', // 更新するテーブル名
      row, // 更新するデータ
      where: 'training_id = ?', // 更新対象の条件
      whereArgs: [id], // プレースホルダの値
    );
  }

  // recordテーブルのデータを取得し、training_menuテーブルと結合してトレーニング名を含める
  Future<List<Map<String, dynamic>>> getRecordWithTrainingName() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT record.*, training_menu.training_name 
    FROM record 
    JOIN training_menu ON record.training_id = training_menu.training_id
  ''');
  }
}
