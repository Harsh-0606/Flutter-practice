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

  void toggleFavorite(WordPair currentWord) {
    if (favrouiteWords.contains(currentWord)) {
      favrouiteWords.remove(currentWord);
    } else {
      favrouiteWords.add(currentWord);
    }
    notifyListeners();
  }
    void removeFavorite(WordPair pair) {
    print('word removed ${favrouiteWords.length}');
    favrouiteWords.remove(pair);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
        break;
      case 1:
        page = Favourite();
        break;
      default:
        throw UnimplementedError("Invalid index $selectedIndex");
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          body: Row(
        children: [
          // to make sure that notch or something else is not covering the content.NavigationRail
          SafeArea(
            child: NavigationRail(
                // to hide the label as we do not have enough space.
                // extended: false,
                extended: constraints.maxWidth >= 600,
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
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) => {
                      setState(() {
                        selectedIndex = value;
                      }),
                    }),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: page,
            ),
          )
        ],
      ));
    });
  }
}

class Favourite extends StatelessWidget {
  const Favourite({super.key});
  @override
  Widget build(BuildContext context) {
    var appstate = context.watch<MyAppState>();

  if(appstate.favrouiteWords.isEmpty){
    return const Center(
      child: Text("No favorites yet 😢"),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
          '${appstate.favrouiteWords.length} favorites:', style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).colorScheme.onPrimary,
          ),),
        ),
        for( var word in appstate.favrouiteWords)
          ListTile(
            leading: IconButton(
              icon: const Icon(Icons.delete, semanticLabel: 'delete',),
              onPressed: () {
                appstate.removeFavorite(word);
              }
              , color: Colors.pink,
              ),
            title: Text(word.asPascalCase, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
          )
        
      ],
    );
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
                  appstate.toggleFavorite(currentWord);
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
