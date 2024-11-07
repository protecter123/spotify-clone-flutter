import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/Providers/PlaylistProvider.dart';

class PlaylistNameScreen extends StatelessWidget {
  final String playlistName;

  const PlaylistNameScreen({super.key, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    // Fetch songs when the screen is first built
    if (playlistProvider.songs.isEmpty && !playlistProvider.isLoading) {
      playlistProvider.fetchSongs();
    }

    return Scaffold(
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            // Back button
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
            const SizedBox(height: 20),

            // Playlist name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$playlistName Playlist',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Tap on song to add into playlist',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Song List
            Expanded(
              child: playlistProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    )
                  : ListView.builder(
                      itemCount: playlistProvider.songs.length,
                      itemBuilder: (context, index) {
                        final song = playlistProvider.songs[index];
                        return ListTile(
                          leading: Image.network(
                            song['coverImageUrl'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            song['title'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            song['artist'],
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                          onTap: () {
                            // Add song to the playlist and save to Firebase when ListTile is tapped
                            playlistProvider
                                .createPlaylist(context, playlistName, [song]);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
