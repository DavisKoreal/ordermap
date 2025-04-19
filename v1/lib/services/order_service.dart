import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/sample_model.dart';

class OrderService {
  static const String _databaseName = 'ordermap.db';
  static const String _tableName = 'orders';
  static const int _databaseVersion = 3;

  Database? _database;

  Future<void> init() async {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            userId TEXT,
            title TEXT,
            amount REAL,
            latitude REAL,
            longitude REAL,
            status TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE $_tableName ADD COLUMN status TEXT');
          await db.execute("UPDATE $_tableName SET status = 'unpicked'");
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE $_tableName ADD COLUMN userId TEXT');
          await db.execute("UPDATE $_tableName SET userId = 'anonymous'");
        }
      },
    );
  }

  Future<void> addOrder(Order order) async {
    final db = _database!;
    await db.insert(
      _tableName,
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Order>> getInProgressOrders({OrderStatus? status}) async {
    final db = _database!;
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    final maps = status == null
        ? await db.query(
            _tableName,
            where: 'userId = ?',
            whereArgs: [userId],
          )
        : await db.query(
            _tableName,
            where: 'userId = ? AND status = ?',
            whereArgs: [userId, status.name],
          );
    return maps.map((map) => Order.fromMap(map)).toList();
  }

  Future<void> clearOrders() async {
    final db = _database!;
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    await db.delete(
      _tableName,
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<void> close() async {
    final db = _database!;
    await db.close();
  }
}