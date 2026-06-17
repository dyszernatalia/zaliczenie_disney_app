import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'database_helper.dart';

void main() {
  runApp(const DisneyApp());
}

class DisneyApp extends StatelessWidget {
  const DisneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Postać Disneya',
      theme: ThemeData(
        colorSchemeSeed: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF0F5),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class Character {
  final int id;
  final String name;
  final String imageUrl;
  final List<dynamic> films;
  final List<dynamic> tvShows;
  final List<dynamic> videoGames;

  Character({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.films,
    required this.tvShows,
    required this.videoGames,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
      imageUrl: json['imageUrl'] ?? '',
      films: json['films'] ?? [],
      tvShows: json['tvShows'] ?? [],
      videoGames: json['videoGames'] ?? [],
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState
    extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const FavoritesScreen(),
    const AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Postacie',
          ),

          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Ulubione',
          ),

          NavigationDestination(
            icon: Icon(Icons.info),
            label: 'O aplikacji',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Character>> characters;

  @override
  void initState() {
    super.initState();
    characters = fetchCharacters();
  }

  Future<List<Character>> fetchCharacters() async {
    final response = await http.get(
      Uri.parse('https://api.disneyapi.dev/character'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['data'] as List)
          .map((e) => Character.fromJson(e))
          .toList();
    }

    throw Exception('Failed to load characters');
  }

  Future<void> refreshData() async {
    setState(() {
      characters = fetchCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        centerTitle: true,
        title: const Text(
          '💕 Disney Characters',
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<List<Character>>(
          future: characters,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Nie udało się pobrać postaci Disneya.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final data = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 16,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final character = data[index];

                return Card(
                  color: Colors.white,
                  shadowColor: Colors.pinkAccent,
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        character.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                    title: Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Postać Disneya',
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.pink,
                      size: 18,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(
                            character,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final Character character;

  const DetailsScreen(
      this.character, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        centerTitle: true,
        title: Text(
          character.name,
          style: const TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
          const EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(20),
                child: Image.network(
                  character.imageUrl,
                  height: 320,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) =>
                  const Icon(
                    Icons.image,
                    size: 150,
                    color: Colors.pink,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                character.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Card(
                color: Colors.white,
                shadowColor: Colors.pinkAccent,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "🎬 Filmy",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        character.films.isEmpty
                            ? "Brak danych"
                            : character.films.join(", "),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "📺 Seriale",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        character.tvShows.isEmpty
                            ? "Brak danych"
                            : character.tvShows.join(", "),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "🎮 Gry",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        character.videoGames.isEmpty
                            ? "Brak danych"
                            : character.videoGames.join(", "),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),

                onPressed: () async {
                  try {
                    await DatabaseHelper.instance.addFavorite(
                      character.id,
                      character.name,
                      character.imageUrl,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${character.name} dodano do ulubionych ❤️',
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                      ),
                    );
                  }
                },

                icon: const Icon(Icons.favorite),
                label: const Text(
                  'Dodaj do ulubionych',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data =
    await DatabaseHelper.instance.getFavorites();

    setState(() {
      favorites = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        centerTitle: true,
        title: const Text(
          '❤️ Ulubione',
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: favorites.isEmpty
          ? const Center(
        child: Text(
          'Brak ulubionych postaci',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final character =
          favorites[index];

          return Card(
            margin:
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: ListTile(
              leading: Image.network(
                character['imageUrl'],
                width: 60,
                errorBuilder:
                    (_, __, ___) =>
                const Icon(
                  Icons.person,
                ),
              ),
              title: Text(
                character['name'],
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  await DatabaseHelper
                      .instance
                      .deleteFavorite(
                    character['id'],
                  );

                  loadFavorites();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFFFF0F5),

      appBar: AppBar(
        backgroundColor:
        Colors.pink.shade100,
        centerTitle: true,
        title: const Text(
          'ℹ️ O aplikacji',
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Aplikacja Postacie Disneya została stworzona w technologii Flutter i wykorzystuje Disney API do pobierania informacji o postaciach.\n\n'
              'Użytkownicy mogą przeglądać postacie, wyświetlać ich szczegóły oraz zapisywać ulubione postacie w lokalnej bazie danych SQLite.',
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}