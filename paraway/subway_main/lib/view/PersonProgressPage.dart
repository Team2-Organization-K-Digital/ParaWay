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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '$stationName역 혼잡도',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.star_border, size: 30),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('즐겨찾기 추가'),
                      content: Text('$stationName역을 즐겨찾기에 추가하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context), // 취소
                          child: Text('아니요'),
                        ),
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
                          child: Text('예'),
                        ),
                      ],
                    ),
              );
            },
          ),
          SizedBox(width: 5),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Checkbox(
                    value: provider.isHoliday,
                    onChanged: (val) => provider.setHoliday(val ?? false),
                  ),
                  Text('공휴일'),
                  Checkbox(
                    value: provider.up,
                    onChanged: (val) {
                      provider.setUp(val ?? false);
                      provider.simulateProgress();
                    },
                  ),
                  Text('내선'),
                  Checkbox(
                    value: provider.out,
                    onChanged: (val) {
                      provider.setOut(val ?? false);
                      provider.simulateProgress();
                    },
                  ),
                  Text('외선'),
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
                    child: Text('조회'),
                  ),
                ],
              ),
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
                child: Text("날짜 & 시간 선택"),
              ),
            ],
          ),
          SizedBox(height: 30, child: Text('5시 ~ 23시')),
          provider.selectedDateTime != null
              ? Text(
                '선택된 날짜: ${provider.selectedDateTime!.year}-${provider.selectedDateTime!.month.toString().padLeft(2, '0')}-${provider.selectedDateTime!.day.toString().padLeft(2, '0')} '
                '${provider.selectedDateTime!.hour.toString().padLeft(2, '0')}:${provider.selectedDateTime!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 16),
              )
              : Text('날짜와 시간을 선택해주세요.'),
          SizedBox(height: 30),
          Row(
            children: [
              Text('승차인원 : ${pred['on']}'),
              SizedBox(width: 20),
              Text('하차인원 : ${pred['off']}'),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Center(
                child:
                    provider.svgShapePath == null
                        ? CircularProgressIndicator()
                        : SizedBox(
                          width: 250,
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
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      )
                      : Text(
                        '${pred['oconfusion']}%',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
