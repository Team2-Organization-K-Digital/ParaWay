// --------------------------------------------------------------------- //
/*
  - title         : Newshandler
  - Description   : Fast api에서 가져오는 뉴스와날씨 정보를 합쳐서 만들기
  - Author        : Jeon Gam Seong
  - Created Date  : 2025.07.17
  - Last Modified : 2025.07.17
  - package       : http

// --------------------------------------------------------------------- //
  [Changelog]
  - 2025.07.17 v1.0.0  :  News와 Weather의 정보를 가져오는
                          FastApi 서버와 연결. Notifier로 메인연결
// --------------------------------------------------------------------- //
*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class NewsHandler with ChangeNotifier{
  
  List<dynamic> weathers = [];
  List<dynamic> headlines = [];
  bool isLoading = true;
  String? error;

    Future<void> fetchAll() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await Future.wait([
        fetchNews(),
        fetchWeather(),
      ]);
    } catch (e) {
      error = "예외 발생: $e";
    } finally {
      isLoading = false;
      notifyListeners(); 
    }
  }

Future<void> fetchNews() async{
  final url = Uri.parse("http://127.0.0.1:8000/newsweather/newscontent");
  final response = await http.get(url);
  if(response.statusCode ==200){
    final data = jsonDecode(response.body);
    headlines = data['results'];
  } else {
    throw Exception("뉴스에러 ${response.statusCode}");
  }
}

Future<void> fetchWeather()async{
  final url = Uri.parse("http://127.0.0.1:8000/newsweather/weather");
  final response = await http.get(url);
  if(response.statusCode == 200){
    final data = jsonDecode(response.body);
    weathers = data['results'];
  } else{
    throw Exception("날씨 에러: ${response.statusCode}");
  }
}
}