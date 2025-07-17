import 'package:flutter/material.dart';
import 'package:subway_main/view/PersonProgressPage.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 100),
          itemCount: stations.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(150,0,0,0),
                  child: Row(
                    children: [
                      SizedBox(width: 30),
                      Column(
                        children: [
                          if (index != 0)
                            Container(width: 4, height: 20, color: Colors.green),
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
                            Container(width: 4, height: 20, color: Colors.green),
                        ],
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
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
                                        Text("혼잡"),
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
                                                            PersonProgressPage(
                                                              stationName: stations[index]
                                                            )
                                                            , // 페이지 이동
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
