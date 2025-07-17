import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:subway_main/model/confusion_pred.dart';
import 'package:subway_main/model/subway_info.dart';
import 'package:http/http.dart' as http;

class PredictHandler with ChangeNotifier {
  final String baseUrl = "http://127.0.0.1:8000";
  Map<String, dynamic> pred = {};
  final List<String> stations = [
    '사당',
    '방배',
    '서초',
    '교대',
    '강남',
    '역삼',
    '선릉',
    '삼성',
    '종합운동장',
    '잠실새내',
    '잠실',
    '잠실나루',
  ];

  loadconfusion(SubwayInfo subinfo) async {
    pred.clear();
    await confPred(subinfo);
    notifyListeners();
  }

  Future<void> confPred(SubwayInfo info) async {
    final url = Uri.parse("$baseUrl/subway/confusion");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(info.toMap()),
    );
    final result = json.decode(utf8.decode(response.bodyBytes));
    print(result);
    pred = result;
  }
}
