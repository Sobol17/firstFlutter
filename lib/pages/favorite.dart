import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test123/main.dart';
/// страница с favorite list
class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var favorites = context.watch<MyAppState>().favorites;
    var appState = context.watch<MyAppState>();
    if (favorites.isEmpty) {
      return Center(
        child: Text('EMPTY'),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have ${favorites.length} favorites:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black12.withOpacity(0.6),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        for (var pair in favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('${pair.first} ${pair.second}'),
            trailing: IconButton(
              onPressed: appState.toggleFavorite,
              icon: Icon(Icons.delete),
            ),
          ),
      ],
    );
  }
}

/// класс отвечающий за "карточку" с кнопками и с сгенерированным текстом
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding (
        padding: const EdgeInsets.all(20),
        child: Text('${pair.first} ${pair.second}', style: style),
      ),
    );
  }
}
