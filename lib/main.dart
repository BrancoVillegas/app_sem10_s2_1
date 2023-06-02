import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RandonWord(),
    );
  }
}

class RandonWord extends StatefulWidget {
  const RandonWord({Key? key}) : super(key: key);

  @override
  State<RandonWord> createState() => _RandonWordState();
}

class _RandonWordState extends State<RandonWord> {
  final List<WordPair> suggestions = <WordPair>[];
  final TextStyle biggerFont = const TextStyle(fontSize: 18);
  final Set<WordPair> saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    //return Text(wordPair.asPascalCase);
    return Scaffold(
      appBar: AppBar(
        title: Text('Generador de Palabras'),
        actions: <Widget>[
          IconButton(
            onPressed: pushSaved,
            icon: Icon(Icons.list_alt_sharp),
          )
        ],
      ),
      body: buildSuggestions(),
    );
  }


  Widget buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16), //opcional
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) {
            return Divider(
              thickness: 3,
              color: Colors.green,
            ); //opcional
          }
          final int index = i ~/ 2; //dividir entre 2 y retornar un entero

          if (index >= suggestions.length) {
            suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(suggestions[index]);
        }
    );
  }

  // aqui utilizamos el ListTile
  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = saved.contains(pair);
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: biggerFont,
        ),
        trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null),
        onTap: () {
          setState(() {
            alreadySaved ? saved.remove(pair) : saved.add(pair);
          });
        },
        leading: Icon(Icons.subtitles, color: Colors.blue)
    );
  }

  void pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
              final Iterable<ListTile> tiles = saved.map(
                      (WordPair pair) {
                    return ListTile(
                      title: Text(
                        pair.asPascalCase,
                        style: biggerFont,
                      ),
                    );
                  }
              );
              final List<Widget> divided = ListTile.divideTiles(
                  context: context,
                  tiles: tiles
              ).toList();
              return Scaffold(
                appBar: AppBar(
                  title: Text('Saved Suggestions'),
                ),
                body: ListView(
                    children: divided
                ),
              );
            })
    );
  }
}


