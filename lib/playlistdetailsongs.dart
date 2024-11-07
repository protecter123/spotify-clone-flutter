import 'package:flutter/material.dart';
import 'package:spotify_clone/AudioPlayer.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final dynamic playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
      appBar: AppBar(
        title: Text(playlist['playlistName']),
        backgroundColor: Colors.black, // Match app bar with background
      ),
      body: ListView.builder(
        itemCount: playlist['songs'].length,
        itemBuilder: (context, index) {
          final song = playlist['songs'][index];

          return GestureDetector(
            onTap: () {
              // Navigate to PlayerScreen with the list of songs and the selected song index
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerScreen(
                    songs: playlist['songs'],
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[850], // Dark container for each song
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    song['coverImageUrl'] ?? 'default-image-url',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  song['title'] ?? 'No Title',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  song['artist'] ?? 'Unknown Artist',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  song['Duration'] ??
                      '00:00', // Show song duration on the right
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
