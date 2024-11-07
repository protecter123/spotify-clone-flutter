import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/AudioPlayer.dart';
import 'package:spotify_clone/Playlist.dart';
import 'package:spotify_clone/services/APIService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  List<dynamic> songs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    try {
      final data = await apiService.fetchSongs();
      setState(() {
        songs = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching songs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 4, 4, 4),
              Color.fromARGB(255, 6, 6, 6), // Start with white
              Color.fromARGB(255, 2, 2, 2), // Fade to black
            ],
            stops: [0.1, 0.2, 0.3],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "All",
                        style: GoogleFonts.roboto(
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Songs",
                        style: GoogleFonts.lobster(
                          fontSize: 36,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/spotify-download-logo-30.png',
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return SongListItem(
                          title: song['title'] ?? 'Unknown Title',
                          artist: song['artist'] ?? 'Unknown Artist',
                          duration: song['Duration'] ?? '0:00',
                          coverImageUrl: song['coverImageUrl'] ?? '',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayerScreen(
                                  songs: songs,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to PlaylistsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PlaylistScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.playlist_play, color: Colors.white),
                  label: const Text(
                    'Playlists',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SongListItem extends StatelessWidget {
  final String title;
  final String artist;
  final String duration;
  final String coverImageUrl;
  final VoidCallback onTap;

  const SongListItem({
    Key? key,
    required this.title,
    required this.artist,
    required this.duration,
    required this.coverImageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(8.0),
        // decoration: BoxDecoration(
        //   color: Colors.transparent,
        //   // boxShadow: [
        //   //   BoxShadow(
        //   //     color: Colors.green.withOpacity(0.5),
        //   //     spreadRadius: 2,
        //   //     blurRadius: 8,
        //   //     offset: Offset(0, 4),
        //   //   ),
        //   // ],
        // ),
        child: Row(
          children: [
            Image.network(
              coverImageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image with Image.network: $error');
                return Icon(Icons.error, color: Colors.white);
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artist,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              duration,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
