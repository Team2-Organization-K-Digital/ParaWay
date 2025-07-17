import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subway_main/model/subway_info.dart';
import 'package:subway_main/view/PersonProgressPage.dart';
import 'package:subway_main/vm/handler_temp.dart';
import 'package:subway_main/vm/predict_handler.dart';

class SubwayLineScreen extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HandlerTemp>();
    final predict = context.watch<PredictHandler>();

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 30),
          itemCount: stations.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(150, 0, 0, 0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          if (index != 0)
                            Container(
                              width: 4,
                              height: 20,
                              color: Colors.green,
                            ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green, width: 4),
                            ),
                          ),
                          if (index != stations.length - 1)
                            Container(
                              width: 4,
                              height: 20,
                              color: Colors.green,
                            ),
                        ],
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          await context.read<HandlerTemp>().loadSubway(
                            stations[index],
                          );
                          final info = vm.info[0];
                          final subInfo = SubwayInfo(
                            subNum: info.subNumber,
                            time: DateTime.now().hour,
                            week: DateTime.now().weekday,
                            stores: info.storeCount,
                            exits: info.subGate,
                            workp: info.officeWorker,
                            holy: false,
                          );
                          await context.read<PredictHandler>().loadconfusion(
                            subInfo,
                          );
                          final pred = predict.pred;
                          showDialog(
                            context: context,
                            builder:
                                (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          stations[index],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          "내선 혼잡도 : ${pred['oconfusion'] < 80
                                              ? '여유'
                                              : pred['oconfusion'] < 130
                                              ? '보통'
                                              : pred['oconfusion'] < 150
                                              ? '주의'
                                              : '혼잡'}",
                                        ),
                                        Text(
                                          "외선 혼잡도 : ${pred['fconfusion'] < 80
                                              ? '여유'
                                              : pred['fconfusion'] < 130
                                              ? '보통'
                                              : pred['fconfusion'] < 150
                                              ? '주의'
                                              : '혼잡'}",
                                        ),
                                        SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: Text("닫기"),
                                            ),
                                            SizedBox(width: 8),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                  context,
                                                ); // 다이얼로그 닫기
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (_) =>
                                                            PersonProgressPage(), // 페이지 이동
                                                  ),
                                                );
                                              },
                                              child: Text("상세보기"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          );
                        },
                        child: Text(
                          stations[index],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
