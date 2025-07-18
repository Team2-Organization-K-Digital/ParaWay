import 'dart:ffi';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:subway_main/view/news_header.dart';
import 'package:subway_main/view/star.dart';
import 'package:subway_main/view/subwayLineScreen.dart';
import 'package:provider/provider.dart';
import 'package:subway_main/vm/PersonProgressProvider.dart';
import 'package:subway_main/vm/favoriteProvider.dart';
import 'package:subway_main/vm/handler_temp.dart';
import 'package:subway_main/vm/news_handler.dart';
import 'package:subway_main/vm/predict_handler.dart';
import 'package:subway_main/vm/tabbar_controller.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => HandlerTemp()),
      ChangeNotifierProvider(create: (context) => PredictHandler()),
      ChangeNotifierProvider(create: (context) => TabbarController()),
      ChangeNotifierProvider(create: (_) => NewsHandler()),
      ChangeNotifierProvider(
        create:
            (_) =>
                PersonProgressProvider()
                  ..loadSvgPath()
                  ..simulateProgress(),
      ),
      ChangeNotifierProvider(create: (_) => FavoriteProvider()),
    ],
    child: MyApp(),
  ),
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
  late bool loading;
  int seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loading = true;
    tabProvider = Provider.of<TabbarController>(context, listen: false);
    tabProvider.init(this, 3);
    Future.microtask(() {
      context.read<NewsHandler>().fetchAll(); // ✅ 빌드 이후 호출
    });
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 7), (timer) {
      loading = false;
      seconds += 1;
      setState(() {});
      if (seconds >= 1) {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    tabProvider.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: TabBarView(
            controller: tabProvider.tabController,
            children: [SubwayLineScreen(), Star(), NewsHeader()],
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: TabBar(
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
          ),
        ),
        Visibility(
          visible: loading,
          child: Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Para Way',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: LinearProgressIndicator(color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
