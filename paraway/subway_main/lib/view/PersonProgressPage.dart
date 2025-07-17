import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class PersonProgressPage extends StatefulWidget {
  const PersonProgressPage({super.key});

  @override
  State<PersonProgressPage> createState() => _PersonProgressPageState();
}

// Liquid Custom Progressor
class _PersonProgressPageState extends State<PersonProgressPage> {
  double _progress = 0.0;
  Path? _svgShapePath;
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    _loadSvgPath();
    _simulateProgress();
  }

  Future<void> _loadSvgPath() async {
    try {
      final Path finalPersonPath = Path();
      final List<String> svgPathDs = [
        "M290 575 c-26 -31 13 -82 44 -56 19 16 21 42 4 59 -16 16 -33 15 -48 -3z",
        """M251 461 c-27 -27 -36 -104 -16 -135 14 -21 16 -47 13 -146 -3 -117
        -2 -120 18 -120 18 0 23 8 27 42 3 24 9 68 13 98 l7 55 8 -40 c4 -22 10 -66
        14 -97 6 -51 9 -58 28 -58 22 0 22 2 19 120 -3 99 -1 125 13 146 12 19 14 36
        9 71 -9 61 -32 83 -89 83 -31 0 -51 -6 -64 -19z""",
      ];
      final Matrix4 transformMatrix =
          Matrix4.identity()
            ..translate(0.0, 600.0)
            ..scale(0.5, -0.5); // 아이콘 크기

      for (final d in svgPathDs) {
        final Path currentPath = parseSvgPathData(d);
        finalPersonPath.addPath(
          currentPath,
          Offset.zero,
          matrix4: transformMatrix.storage,
        );
      }

      finalPersonPath.fillType = PathFillType.nonZero;
      final Rect bounds = finalPersonPath.getBounds();
      finalPersonPath.shift(Offset(0, -bounds.top));

      setState(() {
        _svgShapePath = finalPersonPath;
      });
    } catch (e) {
      print('SVG Path 로드 실패: $e');
    }
  }

  void _simulateProgress() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _progress = 0.3);
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _progress = 0.7);
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      setState(() => _progress = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('해당 역 혼잡도'),
      actions: [
        IconButton(
                  onPressed: () {
                    // 눌렀을때 즐겨찾기에 저장 - 시간이랑 해당 역
                  }, 
                  icon: Icon(Icons.star_border_outlined)
        ) 
      ],
              ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  picker.DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(2025, 7, 1, 6, 0),
                    maxTime: DateTime(2025, 12, 31, 23, 0),
                    currentTime: DateTime(2025, 7, 1, 6, 0),
                    locale: picker.LocaleType.ko,
                    onConfirm: (dateTime) {
                      setState(() {
                        selectedDateTime = dateTime;
                      });
                    },
                  );
                },
                child: Text("날짜 & 시간 선택"),
              ),
              
              // 공휴일 여부 체크박스
              
            ],
          ),
          SizedBox(height: 30,),
          Column(
            children: [
              selectedDateTime != null
                  ? Text(
                    '선택된 날짜: '
                    '${selectedDateTime!.year}-${selectedDateTime!.month.toString().padLeft(2, '0')}-${selectedDateTime!.day.toString().padLeft(2, '0')} '
                    '${selectedDateTime!.hour.toString().padLeft(2, '0')}:${selectedDateTime!.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 16),
                  )
                  : Text('날짜와 시간을 선택해주세요.'),
              SizedBox(height: 30,),
              Row(
                children: [
                  Text('승차인원 : '),
                  SizedBox(width: 20,),
                  Text('하차인원 : ')
                ],
              )
            ],
          ),
          // 혼잡도 사람 아이콘
          Center(
            child:
                _svgShapePath == null
                    ? const CircularProgressIndicator()
                    : SizedBox(
                      width: 700,
                      height: 600,
                      child: LiquidCustomProgressIndicator(
                        value: _progress,
                        direction: Axis.vertical,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation(Colors.red),
                        shapePath: _svgShapePath!,
                        center: Text(
                          "${(_progress * 100).toInt()}%",
                          style: const TextStyle(
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
