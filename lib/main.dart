import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(const MyApp());

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
        home: const MyHomePage(),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        // to make sure that notch or something else is not covering the content.NavigationRail
        SafeArea(
          child: NavigationRail(
              // to hide the label as we do not have enough space.
              extended: false,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text("Home"),
                ),
                NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text(
                      "favorites",
                    ))
              ],
              selectedIndex: 0,
              onDestinationSelected: (value) => {}),
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            child: const GeneratorPage(),
          ),
        )
      ],
    ));
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appstate = context.watch<MyAppState>();
    var currentWord = appstate.currentWord;

    IconData icon;
    if (appstate.favrouiteWords.contains(currentWord)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ConstantText(),
          RandomWords(currentWord: currentWord),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appstate.toggleFavorite();
                },
                icon: Icon(icon),
                label: const Text("Favorite"),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  appstate.getNext();
                },
                child: const Text("Next"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ConstantText extends StatelessWidget {
  const ConstantText({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text("Random Word:",
          style: TextStyle(
              color: theme.colorScheme.onPrimary,
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
      color: theme.colorScheme.onBackground,
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
