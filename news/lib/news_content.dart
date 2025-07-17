import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsContentPage extends StatelessWidget {
  final String title;
  final String content;

  const NewsContentPage({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

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
    // 단순 예제: content가 전부 URL이라 가정
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () => _launchURL(content),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}
