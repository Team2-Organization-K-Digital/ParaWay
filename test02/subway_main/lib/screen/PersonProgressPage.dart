// person_progress_page.dart

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class PersonProgressPage extends StatefulWidget {
  const PersonProgressPage({super.key});

  @override
  State<PersonProgressPage> createState() => _PersonProgressPageState();
}

class _PersonProgressPageState extends State<PersonProgressPage> {
  double _progress = 0.0;
  Path? _svgShapePath;

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
9 71 -9 61 -32 83 -89 83 -31 0 -51 -6 -64 -19z"""
      ];
      final Matrix4 transformMatrix = Matrix4.identity()
        ..translate(0.0, 600.0)
        ..scale(0.5, -0.5);

      for (final d in svgPathDs) {
        final Path currentPath = parseSvgPathData(d);
        finalPersonPath.addPath(currentPath, Offset.zero, matrix4: transformMatrix.storage);
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
      setState(() => _progress = 0.3);
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() => _progress = 0.7);
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() => _progress = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사람 모양 진행률')),
      body: Center(
        child: _svgShapePath == null
            ? const CircularProgressIndicator()
            : SizedBox(
                width: 300,
                height: 600,
                child: LiquidCustomProgressIndicator(
                  value: _progress,
                  direction: Axis.vertical,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation(Colors.blue),
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
    );
  }
}
