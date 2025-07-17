import 'package:flutter/material.dart';

class TabbarController with ChangeNotifier {
  late TabController tabController;

  void init(TickerProvider vsync, int length) {
    tabController = TabController(length: length, vsync: vsync);
    tabController.addListener(() {
      notifyListeners();
    });
  }

  void disposeController() {
    tabController.dispose();
  }
}
