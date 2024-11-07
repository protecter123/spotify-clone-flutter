import 'package:flutter/material.dart';
import 'package:spotify_clone/services/ApiService.dart';

class PlaylistProvider extends ChangeNotifier {
  List<dynamic> _songs = [];
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  List<dynamic> get songs => _songs;
  bool get isLoading => _isLoading;

  Future<void> fetchSongs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _songs = await _apiService.fetchSongs(); // Use ApiService to fetch songs
      print('Success: Songs loaded');
    } catch (error) {
      print('Error fetching songs: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPlaylist(
      BuildContext context, String playlistName, List<dynamic> songs) async {
    // Validate song fields to ensure no undefined values are passed
    print(songs);

    try {
      await _apiService.createPlaylist(
          playlistName, songs); // Use ApiService to create playlist
      print('Playlist created successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Song Added to Playlist successfully to $playlistName '),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (error) {
      print('Error creating playlist: $error');
    }
  }
}
