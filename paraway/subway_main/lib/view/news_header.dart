import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subway_main/view/news_content.dart';
import 'package:subway_main/vm/news_handler.dart';

class NewsHeader extends StatelessWidget {
  const NewsHeader({super.key});



  @override
  Widget build(BuildContext context) {



    final  handler =  context.watch<NewsHandler>();
    final weathers = handler.weathers;
    final headlines = handler.headlines;

    return Scaffold(
      appBar: AppBar(title: Text("뉴스와 날씨")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 날씨 표시
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "오늘의날씨",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ...weathers.map((item) {
                    final text = item['title'] ?? "";
                    IconData icon;

                    if (text.contains("비")) {
                      icon = Icons.cloud;
                    }
                    if (text.contains("눈")) {
                      icon = Icons.ac_unit;
                    } else {}
                    if (text.contains("흐림")) {
                      icon = Icons.cloud;
                    }
                    // if (text.contains("")) {
                    //   icon = Icons.ac_unit;
                    // }
                    else {
                      icon = Icons.wb_sunny;
                    }

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(text, style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            Divider(),
            // 뉴스 표시
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "뉴스 목록",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: headlines.length,
                    itemBuilder: (context, index) {
                      final item = headlines[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => NewsContentPage(
                                    title: item['title'] ?? "",
                                    content: item['content'] ?? "",
                                  ),
                            ),
                          );

                          // Get.to(() => NewsContentPage(
                          //   title: item['title'] ?? "",
                          //   content: item['content'] ?? "",
                          // ));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            item['title'] ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
