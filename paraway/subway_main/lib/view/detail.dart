import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  //
                }, 
                child: Text('날짜선택')
              ),
              ElevatedButton(
                onPressed: () {
                  //
                }, 
                child: Text('시간선택')
              ),
            ],
          )
        ],
      ),
    );
  }
}