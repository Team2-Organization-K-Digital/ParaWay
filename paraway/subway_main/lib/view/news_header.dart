import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'news_content.dart';

class NewsHeader extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<NewsHeader> {
  List<dynamic> weathers = [];
  List<dynamic> headlines = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.wait([fetchNews(), fetchWeather()]);
    } catch (e) {
      setState(() {
        error = "예외 발생: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchNews() async {
    final url = Uri.parse("http://127.0.0.1:8000/newscontent");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      headlines = data['results'];
    } else {
      throw Exception("뉴스 에러: ${response.statusCode}");
    }
  }

  Future<void> fetchWeather() async {
    final url = Uri.parse("http://127.0.0.1:8000/weather");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      weathers = data['results'];
    } else {
      throw Exception("날씨 에러: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("로딩중")),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: Text("에러 발생")),
        body: Center(child: Text(error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("뉴스와 날씨")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 날씨 표시
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "오늘의날씨",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...weathers.map((item) {
                    final text = item['title'] ?? "";
                    IconData icon;

                    if (text.contains("비")) {
                      icon = Icons.cloud;
                    }
                    if (text.contains("눈")) {
                      icon = Icons.ac_unit;
                    } else {}
                    if (text.contains("흐림")) {
                      icon = Icons.cloud;
                    }
                    // if (text.contains("")) {
                    //   icon = Icons.ac_unit;
                    // }
                    else {
                      icon = Icons.wb_sunny;
                    }

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(text, style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            Divider(),
            // 뉴스 표시
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "뉴스 목록",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: headlines.length,
                    itemBuilder: (context, index) {
                      final item = headlines[index];
                      return GestureDetector(
                        onTap: () {
                          // Get.to(() => NewsContentPage(
                          //   title: item['title'] ?? "",
                          //   content: item['content'] ?? "",
                          // ));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            item['title'] ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
