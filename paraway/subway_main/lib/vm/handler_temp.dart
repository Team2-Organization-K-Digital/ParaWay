import 'package:flutter/widgets.dart';
import 'package:subway_main/model/sub_info.dart';
import 'package:subway_main/model/subway_info.dart';
import 'package:subway_main/vm/database_handler.dart';

class HandlerTemp with ChangeNotifier {
  final DatabaseHandler _dbHandler = DatabaseHandler();
  List<SubInfo> _info = [];
  List<SubInfo> get info => _info;

  Future<void> loadSubway(String name) async {
    _info = await _dbHandler.subwayQuery(name);
    notifyListeners();
  }
}
