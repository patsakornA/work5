import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url = 'https://api.sampleapis.com/switch/games';
  List<Game> games = [];
  List<Game> filteredGames = [];
  TextEditingController searchController = TextEditingController();

  Future<void> getGames() async {
    http.Response response = await http.get(Uri.parse(url));
    List<dynamic> jsonData = jsonDecode(response.body);
    List<Game> fetched = jsonData.map((item) {
      return Game(
        id: item['id'],
        name: item['name'],
        genre: List<String>.from(item['genre']),
        developers: List<String>.from(item['developers']),
        publishers: List<String>.from(item['publishers']),
        releaseDates: Map<String, String>.from(item['releaseDates']),
      );
    }).toList();
    setState(() {
      games = fetched;
      filteredGames = games;
    });
  }

  void _searchGames(String query) {
    setState(() {
      filteredGames = games
          .where(
              (game) => game.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showGameDetails(Game game) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(game.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Developers: ${game.developers.join(', ')}'),
              SizedBox(height: 8),
              Text('Publishers: ${game.publishers.join(', ')}'),
              SizedBox(height: 8),
              Text('Genres: ${game.genre.join(', ')}'),
              SizedBox(height: 8),
              Text('Release Dates:'),
              ...game.releaseDates.entries.map((entry) {
                return Text('${entry.key}: ${entry.value}');
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: _searchGames,
          decoration: InputDecoration(
            hintText: 'Search games...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                _searchGames('');
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredGames.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(filteredGames[index].name),
            onTap: () {
              _showGameDetails(filteredGames[index]);
            },
          );
        },
      ),
    );
  }
}
