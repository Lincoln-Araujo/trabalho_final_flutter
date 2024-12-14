import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/dog.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (kIsWeb) throw UnsupportedError('Local database is not supported on web.');
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dogs.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dogs (
        id TEXT PRIMARY KEY,
        name TEXT,
        breed_group TEXT,
        temperament TEXT,
        image_url TEXT,
        life_span TEXT,
        page INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE images (
        id TEXT PRIMARY KEY,
        dog_id TEXT,
        url TEXT,
        width INTEGER,
        height INTEGER,
        FOREIGN KEY (dog_id) REFERENCES dogs (id)
      )
    ''');
  }

  Future<void> insertDog(Dog dog, int page) async {
    if (kIsWeb) return;
    final db = await database;

    await db.insert(
      'dogs',
      {
        'id': dog.id,
        'name': dog.name,
        'breed_group': dog.breedGroup,
        'temperament': dog.temperament,
        'image_url': dog.imageUrl,
        'life_span': dog.lifeSpan,
        'page': page,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (var image in dog.images) {
      await db.insert(
        'images',
        {
          'id': image.id,
          'dog_id': dog.id,
          'url': image.url,
          'width': image.width,
          'height': image.height,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Dog>> fetchDogsByPage(int page, int limit) async {
    if (kIsWeb) throw UnsupportedError('Local database is not supported on web.');
    final db = await database;

    final dogsData = await db.query(
      'dogs',
      where: 'page = ?',
      whereArgs: [page],
    );

    final List<Dog> dogs = [];

    for (var dogData in dogsData) {
      final imagesData = await db.query(
        'images',
        where: 'dog_id = ?',
        whereArgs: [dogData['id']],
      );

      final List<DogImage> images = imagesData.map((img) {
        return DogImage(
          id: img['id'] as String,
          url: img['url'] as String,
          width: img['width'] as int,
          height: img['height'] as int,
        );
      }).toList();

      dogs.add(
        Dog(
          id: dogData['id'] as String,
          name: dogData['name'] as String,
          breedGroup: dogData['breed_group'] as String? ?? '',
          temperament: dogData['temperament'] as String? ?? '',
          imageUrl: dogData['image_url'] as String? ?? '',
          lifeSpan: dogData['life_span'] as String? ?? '',
          images: images,
        ),
      );
    }

    return dogs;
  }

  Future<void> clearData() async {
    if (kIsWeb) return;
    final db = await database;
    await db.delete('dogs');
    await db.delete('images');
  }
}
