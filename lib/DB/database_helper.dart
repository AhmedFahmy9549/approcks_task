import 'package:approcks_task/models/mosque_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Singleton class to manage database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "AppRock.db";

  // database table and column names
  final String _tableName = "masjids";
  final String _columnId = "id";
  final String _columnNameAr = "name_ar";
  final String _columnNameEn = "name_en";
  final String _columnAddress = "address";
  final String _columnImages = "images_url";
  final String _columnDistance = "distance";
  final String _columnLatitude = "latitude";
  final String _columnLongitude = "longitude";

  // Increment this version when you need to change the schema
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    /* // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();*/
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

// SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $_tableName ("
        "$_columnId INTEGER,$_columnNameAr TEXT,$_columnNameEn TEXT,$_columnAddress TEXT,$_columnImages TEXT,$_columnDistance TEXT,$_columnLongitude TEXT,$_columnLatitude TEXT )");
  }

  Future<int> insert(Datum model) async {
    final Database db = await database;
    // `conflictAlgorithm` to use in case the same model is inserted twice.
    // replace any previous data.
    int id = await db.insert(_tableName, model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<bool> queryExistItem(int id) async {
    final Database db = await database;
    List<Map> maps = await db.query(_tableName,
        columns: [_columnId],
        where: '$_columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return true;
    }
    return false;
  }

  Future<List<Datum>> queryMasjads() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return Datum(
            id: maps[i]['id'],
            nameAr: maps[i]['nameAr'],
            nameEn: maps[i]['nameEn'],
            imagesUrl: maps[i]['imagesUrl'],
            address: maps[i]['address'],
            distance: double.parse(maps[i]['distance']),
            longitude: double.parse(maps[i]['longitude']),
            latitude: double.parse(maps[i]['latitude']));
      });
    }
    return null;
  }

  Future<void> delete(String id) async {
    final Database db = await database;

    await db.delete(
      _tableName,
      // Use a `where` clause to delete a specific product.
      where: "id = ?",
      // Pass the product id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final Database db = await database;

    await db.delete(
      _tableName,
    );
  }
}
