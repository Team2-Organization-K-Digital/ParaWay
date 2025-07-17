class SubInfo {
  final String subName;
  final int subNumber;
  final int storeCount;
  final int subGate;
  final int officeWorker;

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