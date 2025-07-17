import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:subway_main/vm/PersonProgressProvider.dart';

class PersonProgressPage extends StatelessWidget {
  const PersonProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PersonProgressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('해당 역 혼잡도'),
        actions: [
          IconButton(
            onPressed: () {
              // 즐겨찾기 저장하기
            },
            icon: Icon(Icons.star_border_outlined, size: 30),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                child: Text("날짜 & 시간 선택"),
              ),
              Checkbox(
                value: provider.isHoliday,
                onChanged: (val) => provider.setHoliday(val ?? false),
              ),
              Text('공휴일'),
              ElevatedButton(
                onPressed: () {
                  //
                },
                child: Text('조회'),
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
            children: [
              Text('승차인원 : '),
              SizedBox(width: 20),
              Text('하차인원 : ')
            ],
          ),
          SizedBox(height: 30),
          Center(
            child: provider.svgShapePath == null
                ? CircularProgressIndicator()
                : SizedBox(
                    width: 400,
                    height: 400,
                    child: LiquidCustomProgressIndicator(
                      value: provider.progress,
                      direction: Axis.vertical,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                      shapePath: provider.svgShapePath!,
                      center: Text(
                        "${(provider.progress * 100).toInt()}%",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
