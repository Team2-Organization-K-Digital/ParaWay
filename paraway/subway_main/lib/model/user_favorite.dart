class UserFavorite {
  int? seq; // DB 에서 자동 생성되는 시퀀스 번호
  final String name; // 사용자가 선택한 역 명
  final String time; // 사용자가 선택한 시간

  UserFavorite({this.seq, required this.name, required this.time});

  factory UserFavorite.fromMap(Map<String, dynamic> res) {
    return UserFavorite(
      seq: res['seq'],
      name: res['sub_name'],
      time: res['time'],
    );
  }
}
