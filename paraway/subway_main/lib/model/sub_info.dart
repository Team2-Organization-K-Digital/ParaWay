class SubInfo {
  final String subName;    // 지하철 역 명
  final int subNumber;     // 지하철 역 번호
  final int storeCount;    // 점포 수
  final int subGate;       // 출구 수
  final int officeWorker;  // 직장인 수

  SubInfo(
    {
      required this.subName,
      required this.subNumber,
      required this.storeCount,
      required this.subGate,
      required this.officeWorker
    }
  );

  factory SubInfo.fromMap(Map<String, dynamic> res){
    return SubInfo(
      subName: res['sub_name'], 
      subNumber: res['sub_number'], 
      storeCount: res['store_count'], 
      subGate: res['sub_gate'], 
      officeWorker: res['office_worker']
    );
  }
}