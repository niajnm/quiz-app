// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// import 'constant.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper.internal();
//   factory DatabaseHelper() => _instance;

//   static Database? _database;

//   // Set the database version here
//   static const int databaseVersion = 1;

//   DatabaseHelper.internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await initDatabase();
//     return _database!;
//   }

//   Future<Database> initDatabase() async {
//     String path = join(await getDatabasesPath(), DATABASE_NAME);
//     return await openDatabase(
//       path,
//       version: databaseVersion,
//       onCreate: _onCreate,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute(
//         'CREATE TABLE $REPO_TABLE($REPO_ID INTEGER PRIMARY KEY AUTOINCREMENT, '
//         '$COLUMN_NAME TEXT, '
//         '$COLUMN_FULL_NAME TEXT, ');
//   }
// }
