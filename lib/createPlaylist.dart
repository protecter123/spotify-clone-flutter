import 'package:flutter/material.dart';
import 'package:spotify_clone/PlaylistAddsong.dart';

class CreatePlaylistScreen extends StatelessWidget {
  const CreatePlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _playlistNameController =
        TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            // Title text
            Text(
              'Add name for playlist',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // TextField for playlist name
            TextField(
              controller: _playlistNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter playlist name',
                hintStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Spacer(),

            // Buttons at the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Cancel'),
                ),
                // Create button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the new screen with the playlist name
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaylistNameScreen(
                          playlistName: _playlistNameController.text,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Create'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
