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
  -                      초기 데이터 삽입 여부를 판별하여 초기 데이터를 삽입하는 함수 작성
// --------------------------------------------------------------------- //
*/
class DatabaseHandler {
  // ------------------------------------- //
  // 초기 데이터 삽입 여부
  int check = 0;
  // ------------------------------------- //
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'ParaWay.db'),
      onCreate: (db, version) async {
        // 지하철 역 정보 테이블
        await db.execute(
          "create table sub_info(sub_name TEXT, sub_number INTEGER, sub_gate INTEGER, store_count INTEGER, office_worker INTEGER)",
        );
        // 사용자 즐겨찾기 테이블
        await db.execute(
          "create table user_favorite(seq INTEGER PRIMARY KEY AUTOINCREMENT, sub_name TEXT, time TEXT)",
        );
        // ------------------------------------- //
        // 초기 데이터 삽입 여부 판별에 따라 데이터 삽입 : 0 = 삽입 전 / 1 = 삽입 후
        if (check == 0) {
          // 초기 데이터 리스트 준비
          final initialData = [
            {
              'sub_name': '강남',
              'sub_number': 222,
              'sub_gate': 12,
              'store_count': 18334,
              'office_worker': 83897,
            },
            {
              'sub_name': '교대',
              'sub_number': 223,
              'sub_gate': 8,
              'store_count': 17394,
              'office_worker': 49584,
            },
            {
              'sub_name': '방배',
              'sub_number': 225,
              'sub_gate': 6,
              'store_count': 2141,
              'office_worker': 19769,
            },
            {
              'sub_name': '사당',
              'sub_number': 226,
              'sub_gate': 14,
              'store_count': 5316,
              'office_worker': 5628,
            },
            {
              'sub_name': '삼성',
              'sub_number': 219,
              'sub_gate': 8,
              'store_count': 7070,
              'office_worker': 130305,
            },
            {
              'sub_name': '서초',
              'sub_number': 224,
              'sub_gate': 7,
              'store_count': 9873,
              'office_worker': 31050,
            },
            {
              'sub_name': '선릉',
              'sub_number': 220,
              'sub_gate': 10,
              'store_count': 21349,
              'office_worker': 91665,
            },
            {
              'sub_name': '역삼',
              'sub_number': 221,
              'sub_gate': 8,
              'store_count': 15071,
              'office_worker': 108813,
            },
            {
              'sub_name': '잠실',
              'sub_number': 216,
              'sub_gate': 16,
              'store_count': 4381,
              'office_worker': 29308,
            },
            {
              'sub_name': '잠실나루',
              'sub_number': 215,
              'sub_gate': 5,
              'store_count': 2244,
              'office_worker': 16740,
            },
            {
              'sub_name': '잠실새내',
              'sub_number': 217,
              'sub_gate': 7,
              'store_count': 2758,
              'office_worker': 16519,
            },
            {
              'sub_name': '종합운동장',
              'sub_number': 218,
              'sub_gate': 6,
              'store_count': 4938,
              'office_worker': 86705,
            },
          ];
          // 초기 데이터 삽입
          for (var row in initialData) {
            await db.insert('sub_info', row);
          }
          check = 1;
        }
        // ------------------------------------- //
      },
      version: 1,
    );
  }

  // ------------------------- star.dart --------------------------------- //
  // 1. user favorite query
  Future favoriteQuery() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT * FROM user_favorite',
    );
    return queryResult.map((d) => UserFavorite.fromMap(d)).toList();
  }

  // --------------------------------------------------------------------- //
  // 2. userfavorite insert
  Future favoriteInsert(UserFavorite favorite) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'INSERT INTO user_favorite(sub_name, time) values(?,?)',
      [favorite.name, favorite.time],
    );
    return result;
  }

  // --------------------------------------------------------------------- //
  // 3. userfavorite delete
  Future favoriteDelete(int seq) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawDelete("DELETE FROM user_favorite WHERE seq = ?", [
      seq,
    ]);
    return result;
  }
  // --------------------------------------------------------------------- //

  // --------------------- subwayLineScreen.dart ------------------------- //
  // 1. sub_info query
  Future subInfoQuery() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT * FROM sub_info',
    );
    return queryResult.map((d) => SubInfo.fromMap(d)).toList();
  }
  // --------------------------------------------------------------------- //

  Future subwayQuery(String name) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT * FROM sub_info where sub_name = "${name}"',
    );
    return queryResult.map((d) => SubInfo.fromMap(d)).toList();
  }
} // class
