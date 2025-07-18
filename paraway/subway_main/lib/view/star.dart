import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subway_main/view/PersonProgressPage.dart';
import 'package:subway_main/vm/PersonProgressProvider.dart';
import 'package:subway_main/vm/favoriteProvider.dart';
import 'package:subway_main/model/user_favorite.dart';

class Star extends StatelessWidget {
  const Star({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();

    // 최초 진입 시 로드 (처음 한 번만 호출)
    if (provider.favorites.isEmpty) {
      Future.microtask(() => context.read<FavoriteProvider>().loadFavorites());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('즐겨찾기', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body:
          provider.favorites.isEmpty
              ? Center(child: Text('즐겨찾기가 없습니다.'))
              : ListView.builder(
                itemCount: provider.favorites.length,
                itemBuilder: (context, index) {
                  final item = provider.favorites[index];
                  return ListTile(
                    leading: Icon(Icons.star, color: Colors.amber),
                    title: Text(item.name),
                    subtitle: Text('시간: ${item.time}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed:
                          () => context.read<FavoriteProvider>().deleteFavorite(
                            item.seq!,
                          ),
                    ),
                    onTap: () {
                      DateTime now = DateTime.now();
                      context
                          .read<PersonProgressProvider>()
                          .selectedDateTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        int.parse(item.time.split(':')[0]), // 시(hour)
                        int.parse(item.time.split(':')[1]), // 분(minute)
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => PersonProgressPage(stationName: item.name),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
