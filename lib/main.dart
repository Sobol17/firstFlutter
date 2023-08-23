import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test123/pages/todo.dart';
import 'package:test123/pages/favorite.dart';

// main функция, в ней запускаем flutter приложение
void main() {
  runApp(const MyApp());
}
// класс приложения, с основными параметрами
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, //выключить баннер debug
        title: 'My Flutter App', //название приложения
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
        ),
        home: MyHomePage(), // начальна точка приложения
      ),
    );
  }
}

/// класс состояния приложения
/// Состояние создается и предоставляется всему приложению с помощью
/// ChangeNotifierProvider (см. код выше в MyApp). Это позволяет любому виджету
/// в приложении получить информацию о состоянии.
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];

  void getNext() {
    current = WordPair.random();
    ///Метод getNext() переназначает current новой случайной парой слов.
    ///Он также вызывает notifyListeners() (метод ChangeNotifier),
    ///который гарантирует, что все, кто следит за MyAppState, будут оповещены.
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  List<Todo> todos = [];
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// "_" - означает что это приватный класс
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MainPage();
        break;
      case 1:
        page = FavoritePage();
        break;
      case 2:
        page = TodoPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex index');
    }
    return LayoutBuilder(
      builder: (context, constrains) {
        return Scaffold(
          body: Row(
            children: [
              /// виджет меню
              /// SafeArea обеспечивает что область не будет заслонена строкой
              /// состояния мобилы либо "челкой"
              SafeArea(
                child: NavigationRail( ///навигационный рельс
                  extended: constrains.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
                    NavigationRailDestination(icon: Icon(Icons.today_outlined), label: Text('ToDo List')),
                  ],
                  /// индекс элемента меню (destination rail)
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              /// виджет основного контента, занимает все место, которое доступно
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

/// основная часть страницы вынесена в класс Main
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    /// Задаем иконку с помощью IconData
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Change'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



