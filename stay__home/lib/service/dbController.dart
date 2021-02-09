import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stay__home/model/uesr.dart';

// 선언된 데이터베이스 구조
// user(
// id INTEGER PRIMARY KEY,
// name TEXT,
// topTime INTEGER,
// accTime INTEGER,
// latitude REAL,
// longitude REAl)

/*
 * DBController 예제
 * 
 * var user = User(
 *  id: 0,
 *  name: "홈밍이321jklena213",
 *  topTime: 0,
 *  accTime: 0,
 *  latitude: 0.0,
 *  longitude: 0.0,
 * );
 *  
 * // 데이터베이스에 user를 추가한다.
 * await insertUser(user);
 * 
 * // User 목록을 출력한다. (현재도 미래도 하나만 존재할 예정)
 * print(await user());
 * 
 * // User의 이름을 수정한 뒤 데이터베이스에 저장한다. 
 * user = User(
 *  id: user.id,
 *  name: 바뀐이름,
 *  ...
 * );
 * await updateUser(user);
 * 
 * // User의 수정된 정보를 출력한다.
 * print(await user());
 * 
 * // User를 데이터베이스에서 제거한다.
 * await deleteUser(user.id);
 * 
 * // user 목록을 출력한다. (초창기엔 비어있음.)
 * print(await user());
 */

class DBController {
  var database;

  void onInit() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'stayHome_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE user(id INTEGER PRIMARY KEY,name TEXT, topTime INTEGER, accTime INTEGER, latitude REAL, longitude REAl)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertUser(User user) async {
    //  데이터베이스 reference를 얻는다.
    final Database db = await database;

    /*
     * User를 올바른 테이블에 추가해야한다.
     * 또한 'ConflictAlgorithm'을 명시할 것이다.
     * 여기에서는 만약 동일한 User가 여러번 추가되면, 이전 데이터를 덮어쓸 것이다.
     */
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> user() async {
    //  데이터베이스 reference를 얻는다.
    final Database db = await database;

    //  모든 User를 얻기 위해 테이블에 질의한다.
    final List<Map<String, dynamic>> maps = await db.query('user');

    //  List<Map<String, dynamic>>를 List<User>으로 변환한다.
    return List.generate(maps.length, (_) {
      return User(
        id: maps[_]['id'],
        name: maps[_]['name'],
        topTime: maps[_]['topTime'],
        accTime: maps[_]['accTime'],
        latitude: maps[_]['latitude'],
        longitude: maps[_]['longitude'],
      );
    });
  }

  Future<void> updateUser(User user) async {
    //  데이터베이스 reference를 얻는다
    final Database db = await database;

    //  주어진 USer를 수정한다.
    await db.update(
      'user',
      user.toMap(),
      //  User의 id가 일치하는 지 확인한다.
      where: "id = ?",
      //  User의 id를 whereArg로 넘겨 SQL injection을 방지한다.
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(String name) async {
    //  데이터베이스 reference를 얻는다.
    final Database db = await database;

    //  데이터베이스에서 User를 삭제한다.
    await db.delete(
      'user',
      //  특정 user을 제거하기 위해 'where'절을 사용한다.
      where: "name = ?",
      //  User의 id를 where의 인자로 넘겨 SQL injection을 방지한다.
      whereArgs: [name],
    );
  }
}
