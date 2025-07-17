import 'package:flutter/material.dart';
import 'package:subway_main/view/PersonProgressPage.dart';
import 'package:subway_main/view/news_header.dart';
import 'package:subway_main/view/star.dart';
import 'package:subway_main/view/subwayLineScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Tabbar(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Tabbar extends StatelessWidget {
  const Tabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 탭 개수 추가
      child: Scaffold(
        body: TabBarView(
          children: [
            SubwayLineScreen(),
            Star(),
            NewsHeader(), // 뉴스헤더추가
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: "홈"),
            Tab(icon: Icon(Icons.star), text: "즐겨찾기"),
            Tab(icon: Icon(Icons.newspaper), text: "뉴스"), // 뉴스탭추가
          ],
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
