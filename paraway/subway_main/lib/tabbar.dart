import 'package:flutter/material.dart';
import 'package:subway_main/view/news_header.dart';
import 'package:subway_main/view/star.dart';
import 'package:subway_main/view/subwayLineScreen.dart';
import 'package:provider/provider.dart';
import 'package:subway_main/vm/PersonProgressProvider.dart';
import 'package:subway_main/vm/tabbar_controller.dart';

void main() => runApp(
  MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => TabbarController()),
    ChangeNotifierProvider(
      create: (_) => PersonProgressProvider()
        ..loadSvgPath()
        ..simulateProgress(),
    ),
  ],
  child: MyApp(),
)

);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Tabbar(), debugShowCheckedModeBanner: false);
  }
}

class Tabbar extends StatefulWidget {
  Tabbar({super.key});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with TickerProviderStateMixin {
  late TabbarController tabProvider;

  @override
  void initState() {
    super.initState();
    tabProvider = Provider.of<TabbarController>(context, listen: false);
    tabProvider.init(this, 3);
  }

  @override
  void dispose() {
    tabProvider.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabProvider.tabController,
        children: [
          SubwayLineScreen(), 
          Star(), NewsHeader()],
      ),
      bottomNavigationBar: TabBar(
        controller: tabProvider.tabController,
        tabs: [
          Tab(icon: Icon(Icons.home), text: "홈"),
          Tab(icon: Icon(Icons.star), text: "즐겨찾기"),
          Tab(icon: Icon(Icons.newspaper), text: "뉴스"),
        ],

        labelColor: Colors.green,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.green,
      ),
    );
  }
}
