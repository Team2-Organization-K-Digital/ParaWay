import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:subway_main/model/user_favorite.dart';
import 'package:subway_main/vm/PersonProgressProvider.dart';
import 'package:subway_main/vm/favoriteProvider.dart';

class PersonProgressPage extends StatelessWidget {
  final String stationName;
  const PersonProgressPage({super.key, required this.stationName});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PersonProgressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('$stationName역 혼잡도',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: Icon(Icons.star_border, size: 30,),
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
                              SnackBar(content: Text('즐겨찾기에 추가되었습니다'),
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
          SizedBox(width: 5,)
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
                onChanged: (val) => provider.setUpOut(val ?? false),
              ),
              Text('상선'),
              Checkbox(
                value: provider.out,
                onChanged: (val) => provider.setUpOut(val ?? false),
              ),
              Text('외선'),
              ElevatedButton(
                onPressed: () {
                  //
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
          SizedBox(height: 30),
          provider.selectedDateTime != null
              ? Text(
                '선택된 날짜: ${provider.selectedDateTime!.year}-${provider.selectedDateTime!.month.toString().padLeft(2, '0')}-${provider.selectedDateTime!.day.toString().padLeft(2, '0')} '
                '${provider.selectedDateTime!.hour.toString().padLeft(2, '0')}:${provider.selectedDateTime!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 16),
              )
              : Text('날짜와 시간을 선택해주세요.'),
          SizedBox(height: 30),
          Row(
            children: [Text('승차인원 : '), SizedBox(width: 20), Text('하차인원 : ')],
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
                            value: provider.progress,
                            direction: Axis.vertical,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation(
                              provider.progress <= 80
                                  ? Colors.green
                                  : provider.progress <= 120
                                  ? Colors.amber
                                  : Colors.red,
                            ),
                            shapePath: provider.svgShapePath!,
                            center: Text(
                              "${(provider.progress).toDouble()}%",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
              ),
              Column(
                children: [
                  Text('혼잡도', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  Text('${provider.progress}%', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
