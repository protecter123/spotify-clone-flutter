import 'package:flutter/material.dart';
import 'package:spotify_clone/playlistdetailsongs.dart';
import 'package:spotify_clone/createPlaylist.dart';
import 'package:spotify_clone/services/APIService.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late Future<List<dynamic>> playlistsFuture;

  @override
  void initState() {
    super.initState();
    playlistsFuture = ApiService().fetchPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        title: const Text('Playlists'),
        backgroundColor: Colors.green, // Match app bar color with background
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: FutureBuilder<List<dynamic>>(
          future: playlistsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No playlists available.'));
            }

            final playlists = snapshot.data!;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.2, // Adjust for a more rectangular look
              ),
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];

                return GestureDetector(
                  onTap: () {
                    // Navigate to the playlist detail page with the playlist name
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlaylistDetailScreen(playlist: playlist),
                      ),
                    );
                  },
                  child: Card(
                    color: const Color.fromARGB(
                        255, 251, 253, 251), // Dark card color to match theme
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          16), // Rounded corners for the card
                    ),
                    elevation: 4, // Add shadow for depth
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Full-width placeholder image
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.asset(
                            'assets/PlaylistPlaceholder.jpg', // Use a placeholder image
                            fit: BoxFit.cover,
                            width: double.infinity, // Make image full width
                            height: 120, // Set fixed height for image
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Playlist title text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            playlist['playlistName'] ?? 'No name',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 7, 7,
                                  7), // White text color for visibility
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(bottom: 24.0), // Add space from the bottom
        child: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to the Create Playlist screen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreatePlaylistScreen()),
            );
          },
          backgroundColor: Colors.green, // Set button background to green
          label: Row(
            children: const [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Create new Playlist',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(30), // Rounded corners for the button
          ),
        ),
      ),
    );
  }
}
