import 'package:flutter/material.dart';

class SubwayLineScreen extends StatelessWidget {
  final List<String> stations = [
    '사당', '방배', '서초', '교대', '강남',
    '역삼', '선릉', '삼성', '종합운동장', '잠실새내', '잠실', '잠실나루',
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          Container(width: 4, height:20, color: Colors.green),
                      ],
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Positioned(
                      left: 100,
                      top: -10,
                      child: Container(
                        width: 140,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            )
                          ],
                        )
                      )
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          Dialog(
                            //
                          );
                        },
                        child: Text(
                          stations[index],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

