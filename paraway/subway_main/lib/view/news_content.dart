import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

class NewsContentPage extends StatelessWidget {
  final String title;
  final String content;

  const NewsContentPage({Key? key, required this.title, required this.content})
    : super(key: key);

  // URL이 유효한지 검사 후 launch
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 단순 방식: content가 전부 URL이라 가정하고 url -> 링크로변환. 콘텐츠사이에 url은 다른방식으로
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(title), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            GestureDetector(
              onTap: () => _launchURL(content),
              child: Text(
                content,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            LinkPreview(
              onLinkPreviewDataFetched: (_) {}, // onlink..는필수 무슨기능인지는모름
              text: content,
            ), // 여기
          ],
        ),
      ),
    );
  }
}
