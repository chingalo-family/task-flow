import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDbProvider {
  Database? _db;

  final String databaseName = 'task_manager';
  // Script for migrations as well as intialization of tables
  final List<String> initialQuery = [
    'CREATE TABLE IF NOT EXISTS task ( id TEXT PRIMARY KEY, title TEXT, description TEXT,status TEXT,createdOn TEXT,createdBy TEXT,dueDate TEXT,completedOn TEXT,completedBy TEXT,assignedTo TEXT,groupId TEXT)',
    'CREATE TABLE IF NOT EXISTS sub_task (id TEXT PRIMARY KEY, taskId INTEGER, title TEXT, status TEXT, isCompleted INTEGER, createdOn TEXT,createdBy TEXT,dueDate TEXT,completedOn TEXT,completedBy TEXT,assignedTo TEXT)',
    'CREATE TABLE IF NOT EXISTS user (id TEXT PRIMARY KEY, username TEXT, fullName TEXT, password TEXT, email TEXT, phoneNumber TEXT,gender TEXT, isLogin TEXT)',
    'CREATE TABLE IF NOT EXISTS user_group (id TEXT PRIMARY KEY, name TEXT, createdBy TEXT)',
    'CREATE TABLE IF NOT EXISTS user_group_member (id TEXT PRIMARY KEY, userId TEXT, groupId TEXT, fullName TEXT, username TEXT)'
  ];

  final List<String> migrationQuery = [];

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await init();
    return _db;
  }

  init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$databaseName.db');
    return await openDatabase(
      path,
      version: migrationQuery.length + 1,
      onUpgrade: onUpgrade,
      onConfigure: onConfigure,
      onCreate: onCreate,
      onDowngrade: onDowngrade,
      onOpen: onOpen,
    );
  }

  onOpen(Database db) {}

  onDowngrade(Database db, int oldVersion, int newVersion) {}

  onConfigure(Database db) {}

  onCreate(Database db, int version) async {
    List queries = [...initialQuery, ...migrationQuery];
    for (String query in queries) {
      try {
        await db.execute(query);
      } catch (error) {
        //
      }
    }
  }

  onUpgrade(Database db, int oldVersion, int version) async {
    for (String query in migrationQuery) {
      try {
        await db.execute(query);
      } catch (error) {
        //
      }
    }
  }

  close() async {
    try {
      var dbClient = await db;
      dbClient!.close();
    } catch (e) {
      //
    }
  }
}
