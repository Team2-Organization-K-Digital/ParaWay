class SubwayInfo {
  final int subNum; // 지하철 역 번호
  final int time; // 시간
  final int week; // 요일
  final int stores; // 점포 수
  final int exits; // 출구 수
  final int workp; // 직장인 수
  final bool holy; // 공휴일 판별

  SubwayInfo({
    required this.subNum,
    required this.time,
    required this.week,
    required this.stores,
    required this.exits,
    required this.workp,
    required this.holy,
  });

  Map<String, dynamic> toMap() {
    return {
      'sub_num': subNum,
      'time': time,
      'week': week,
      'stores': stores,
      'exits': exits,
      'workp': workp,
      'holy': holy,
    };
  }
}
