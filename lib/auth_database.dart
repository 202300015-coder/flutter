import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AuthDatabase {
  AuthDatabase._();

  static final AuthDatabase instance = AuthDatabase._();

  static const String _databaseName = 'auth_app.db';
  static const int _databaseVersion = 2;
  static const String _tableUsers = 'users';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final dbPath = join(databasesPath, _databaseName);

      return openDatabase(
        dbPath,
        version: _databaseVersion,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_tableUsers (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT NOT NULL UNIQUE,
              email TEXT NOT NULL UNIQUE,
              password_hash TEXT NOT NULL
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('DROP TABLE IF EXISTS $_tableUsers');
            await db.execute('''
              CREATE TABLE $_tableUsers (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL UNIQUE,
                email TEXT NOT NULL UNIQUE,
                password_hash TEXT NOT NULL
              )
            ''');
          }
        },
      );
    } catch (error) {
      throw Exception('No se pudo abrir la base de datos: $error');
    }
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<bool> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final db = await database;
      final cleanUsername = username.trim().toLowerCase();
      final cleanEmail = email.trim().toLowerCase();

      final existingUser = await db.query(
        _tableUsers,
        where: 'username = ? OR email = ?',
        whereArgs: [cleanUsername, cleanEmail],
        limit: 1,
      );

      if (existingUser.isNotEmpty) {
        return false;
      }

      await db.insert(
        _tableUsers,
        <String, dynamic>{
          'username': cleanUsername,
          'email': cleanEmail,
          'password_hash': hashPassword(password),
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      return true;
    } catch (error) {
      throw Exception('No se pudo registrar el usuario: $error');
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final db = await database;
      final cleanEmail = email.trim().toLowerCase();
      final user = await db.query(
        _tableUsers,
        where: 'email = ? AND password_hash = ?',
        whereArgs: [cleanEmail, hashPassword(password)],
        limit: 1,
      );

      return user.isNotEmpty;
    } catch (error) {
      throw Exception('No se pudo iniciar sesión: $error');
    }
  }
}
