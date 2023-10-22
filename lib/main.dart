import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "random words generator",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var currentWord = WordPair.random();

  void getNext() {
    currentWord = WordPair.random();
    notifyListeners();
  }

  var favrouiteWords = <WordPair>[];

  void toggleFavorite() {
    if (favrouiteWords.contains(currentWord)) {
      favrouiteWords.remove(currentWord);
    } else {
      favrouiteWords.add(currentWord);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appstate = context.watch<MyAppState>();
    var currentWord = appstate.currentWord;

    IconData icon;
    if (appstate.favrouiteWords.contains(currentWord)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border_sharp;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstantText(),
            RandomWords(currentWord: currentWord),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appstate.toggleFavorite();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: const StadiumBorder(),
                    elevation: 20,
                  ),
                  icon: Icon(
                    icon,
                    color: Colors.pink,
                  ),
                  label: const Text("Favorite"),
                ),

                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    appstate.getNext();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: const StadiumBorder(),
                    elevation: 20,
                  ),
                  child: const Text("Next Word"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ConstantText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text("Random Word:",
          style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 30)),
    );
  }
}

class RandomWords extends StatelessWidget {
  const RandomWords({
    super.key,
    required this.currentWord,
  });

  final WordPair currentWord;

  @override
  Widget build(BuildContext context) {
    //calling the theme from the main context
    final theme = Theme.of(context);
    return Card(
      //setting the color of the card behind the random words
      // color: theme.colorScheme.primary, ==> could set the color like this using the theme
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          currentWord.asPascalCase,
          style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 30),
          semanticsLabel: "${currentWord.first} ${currentWord.second}",
        ),
      ),
    );
  }
}
