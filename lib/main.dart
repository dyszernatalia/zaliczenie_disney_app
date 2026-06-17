import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const DisneyApp());
}

class DisneyApp extends StatelessWidget {
  const DisneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Disney Characters',
      theme: ThemeData(
        colorSchemeSeed: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF0F5),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class Character {
  final int id;
  final String name;
  final String imageUrl;

  Character({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
      imageUrl: json['imageUrl'] ?? '',
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
                  'Could not load Disney characters.',
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
                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(12),
                      child: Image.network(
                        character.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) =>
                        const Icon(
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
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Disney Character',
                    ),
                    trailing: const Icon(
                      Icons.favorite,
                      color: Colors.pink,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailsScreen(
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
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                      16),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.all(
                      20),
                  child: Text(
                    "${character.name} is one of the characters from the Disney universe.\n\n"
                        "Disney characters have entertained audiences around the world for generations and remain some of the most recognizable fictional characters ever created.\n\n"
                        "The information displayed in this application is fetched directly from the Disney API.\n\n"
                        "This application was created using Flutter and allows users to browse Disney characters, view their images and explore information about them.",
                    textAlign:
                    TextAlign.center,
                    style:
                    const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}