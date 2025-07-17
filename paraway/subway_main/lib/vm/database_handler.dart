// --------------------------------------------------------------------- //
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:subway_main/model/sub_info.dart';
import 'package:subway_main/model/user_favorite.dart';
// --------------------------------------------------------------------- //
/*
  - title         : SQLite Database Handler
  - Description   : 지하철 혼잡도 예측 앱에서 사용할 local database 구성과
  -                 database 를 handling 하는 sql 문 함수를 구성하는 시트
  - Author        : Lee ChangJun
  - Created Date  : 2025.07.17
  - Last Modified : 2025.07.17
  - package       : path, sqflite

// --------------------------------------------------------------------- //
  [Changelog]
  - 2025.07.17 v1.0.0  : ParaWay.db 생성 및 테이블 생성
  -                      user_favorite table 의 query, insert, drop 함수 작성
  -                      sub_info table 의 query 함수 작성
// --------------------------------------------------------------------- //
*/
class DatabaseHandler {
  Future<Database> initializeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'ParaWay.db'),
      onCreate: (db, version) async{
// 지하철 역 정보 테이블
        await db.execute(
          "create table sub_info(sub_name TEXT, sub_number INTEGER, store_count INTEGER, sub_gate INTEGER, office_worker INTEGER)"
        );
// 사용자 즐겨찾기 테이블
        await db.execute(
          "create table user_favorite(seq INTEGER AUTOINCREMENT, sub_name TEXT, time TEXT)"
        );
      },
      version: 1,
    );
  }
// ------------------------- star.dart --------------------------------- //
// 1. user favorite query
  Future favoriteQuery()async{
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT * FROM user_favorite'
    );
    return queryResult.map((d) => UserFavorite.fromMap(d)).toList();
  }
// --------------------------------------------------------------------- //
// 2. userfavorite insert
  Future favoriteInsert(UserFavorite favorite)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'INSERT INTO user_favorite(sub_name, time)',
      [favorite.name, favorite.time]
    );
    return result;
  }
// --------------------------------------------------------------------- //
// 3. userfavorite delete
  Future favoriteDelete(int seq)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawDelete(
      "DELETE FROM user_favorite WHERE seq = ?",
      [seq]
    );
    return result;
  }
// --------------------------------------------------------------------- //

// --------------------- subwayLineScreen.dart ------------------------- //
// 1. sub_info query
  Future subInfoQuery()async{
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    'SELECT * FROM sub_info'
  );
  return queryResult.map((d) => SubInfo.fromMap(d)).toList();
}
// --------------------------------------------------------------------- //
} // class