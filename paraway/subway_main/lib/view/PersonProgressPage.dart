import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:subway_main/model/subway_info.dart';
import 'package:subway_main/model/user_favorite.dart';
import 'package:subway_main/vm/PersonProgressProvider.dart';
import 'package:subway_main/vm/favoriteProvider.dart';
import 'package:subway_main/vm/handler_temp.dart';
import 'package:subway_main/vm/predict_handler.dart';

class PersonProgressPage extends StatelessWidget {
  final String stationName;
  const PersonProgressPage({super.key, required this.stationName});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PersonProgressProvider>(context);
    final pred = context.read<PredictHandler>().pred;
    final DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '$stationName역 혼잡도',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
            child: IconButton(
              icon: Icon(Icons.star_border, size: 30),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text('즐겨찾기 추가', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                        content: Text('$stationName역을 즐겨찾기에 추가하시겠습니까?', style: TextStyle(fontSize: 17),),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context), // 취소
                            child: Text('아니요', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(width: 120,),
                          TextButton(
                            onPressed: () {
                              final favorite = UserFavorite(
                                name: stationName,
                                time:
                                    "${provider.selectedDateTime!.hour.toString().padLeft(2, '0')}:${provider.selectedDateTime!.minute.toString().padLeft(2, '0')}",
                              );
                              context.read<FavoriteProvider>().addFavorite(
                                favorite,
                              );
                              Navigator.pop(context); // 다이얼로그 닫기
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('즐겨찾기에 추가되었습니다'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Text('예', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 8),
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 58),
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                    value: provider.isHoliday,
                    onChanged: (val) => provider.setHoliday(val ?? false),
                  ),
                  Text(
                    '공휴일',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 15),
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                    value: provider.up,
                    onChanged: (val) {
                      provider.setUp(val ?? false);
                      provider.simulateProgress();
                    },
                  ),
                  Text(
                    '내선',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 15),
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.black,
                    value: provider.out,
                    onChanged: (val) {
                      provider.setOut(val ?? false);
                      provider.simulateProgress();
                    },
                  ),
                  Text(
                    '외선',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: Divider(height: 2, thickness: 2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      picker.DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2025, 12, 31, 23, 0),
                        currentTime: DateTime.now(),
                        locale: picker.LocaleType.ko,
                        onConfirm: (dateTime) {
                          provider.setDateTime(dateTime);
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // 버튼 배경색
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4, // 글자색
                    ),
                    child: Text(
                      "날짜 / 시간 선택",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final info =
                          Provider.of<HandlerTemp>(
                            context,
                            listen: false,
                          ).info[0];
                      final predict = Provider.of<PredictHandler>(
                        context,
                        listen: false,
                      );
                      SubwayInfo feature = SubwayInfo(
                        subNum: info.subNumber,
                        time: provider.selectedDateTime!.hour,
                        week: provider.selectedDateTime!.weekday,
                        stores: info.storeCount,
                        exits: info.subGate,
                        workp: info.officeWorker,
                        holy: provider.isHoliday,
                      );

                      await context.read<PredictHandler>().loadconfusion(
                        feature,
                      );
                      final pred = predict.pred;
                      provider.setPredData(pred);
                      provider.simulateProgress();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // 버튼 배경색
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4, // 글자색
                    ),
                    child: Text(
                      '조회',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  picker.DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(now.year, now.month, now.day, 6, 0),
                    maxTime: DateTime(2025, 12, 31, 23, 0),
                    currentTime: DateTime.now(),
                    locale: picker.LocaleType.ko,
                    onConfirm: (dateTime) {
                      provider.setDateTime(dateTime);
                    },
                  );
                },
                child: Text("날짜 & 시간 선택"),
              ),
            ],
          ),
          SizedBox(height: 30, child: Text('6시 ~ 23시 (1시간 단위)')),
          provider.selectedDateTime != null
              ? Text(
                '선택된 날짜: ${provider.selectedDateTime!.year}-${provider.selectedDateTime!.month.toString().padLeft(2, '0')}-${provider.selectedDateTime!.day.toString().padLeft(2, '0')} '
                '${provider.selectedDateTime!.hour.toString().padLeft(2, '0')}:${provider.selectedDateTime!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 16),
              )
              : Text('날짜와 시간을 선택해주세요.'),
          SizedBox(height: 30),
          SizedBox(height: 18),
          Row(
            children: [
              SizedBox(width: 30),
              Icon(Icons.calendar_month_sharp),
              provider.selectedDateTime != null
                  ? Text(
                    '  ${provider.selectedDateTime!.month.toString().padLeft(2, '0')}월 ${provider.selectedDateTime!.day.toString().padLeft(2, '0')}일 \t'
                    '${provider.selectedDateTime!.hour.toString().padLeft(2, '0')} : ${provider.selectedDateTime!.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  )
                  : Text(
                    '날짜와 시간을 선택해주세요.',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
              SizedBox(width: 20),
              SizedBox(
                child: Text(
                  '( 선택 가능 시간 : 6시 - 23시 )',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: [
              provider.svgShapePath == null
                  ? CircularProgressIndicator()
                  : SizedBox(
                    width: 220,
                    height: 300,
                    child: LiquidCustomProgressIndicator(
                      value: pred['oconfusion'],
                      direction: Axis.vertical,
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          provider.out == true
                              ? AlwaysStoppedAnimation(
                                pred['fconfusion'] <= 80
                                    ? Colors.green
                                    : pred['fconfusion'] <= 120
                                    ? Colors.amber 
                                    : Colors.red,
                              )
                              : AlwaysStoppedAnimation(
                                pred['oconfusion'] <= 80
                                    ? Colors.green
                                    : pred['oconfusion'] <= 120
                                    ? Colors.amber
                                    : Colors.red,
                              ), 
                      shapePath: provider.svgShapePath!,
                      center: Text(
                        provider.out == true
                            ? "${(pred['fconfusion']).toDouble()}%"
                            : "${(pred['oconfusion']).toDouble()}%",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              Column(
                children: [
                  Text(
                    provider.out == true ? '외선 혼잡도' : '내선 혼잡도',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  provider.out == true
                      ? Text(
                        '${pred['fconfusion']}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      )
                      : Text(
                        '${pred['oconfusion']}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          
                          fontSize: 25,
                        ),
                      ),
          SizedBox(height: 15),
          Text( 
            '승차인원 : ${pred['on']}',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          SizedBox(height: 15),
          Text(
            '하차인원 : ${pred['off']}',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          // SizedBox(width: 50,) 
                ],
              ),
            ],
          ),
        ],
      ),
      
    );
  }
}
