import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://192.168.1.119:3000'; // or use your IP address if testing on mobile

  // Fetch Songs
  Future<List<dynamic>> fetchSongs() async {
    final response = await http.get(Uri.parse('$baseUrl/songs'));
    if (response.statusCode == 200) {
      print('success to load songs');
      return jsonDecode(response.body);
    } else {
      print('failed to load songs');
      throw Exception('Failed to load songs');
    }
  }

  // Fetch Playlists
  Future<List<dynamic>> fetchPlaylists() async {
    final response = await http.get(Uri.parse('$baseUrl/user/playlists'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load playlists');
    }
  }

  Future<void> createPlaylist(String playlistName, List<dynamic> songs) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/playlists'),
        headers: {
          'Content-Type': 'application/json'
        }, // Make sure this header is set
        body: jsonEncode({
          'playlistName': playlistName,
          'songs': songs,
        }),
      );

      if (response.statusCode == 201) {
        print('Playlist created successfully');
        
      } else {
        print('Failed to create playlist: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create playlist');
      }
    } catch (error) {
      print('Error making API request: $error');
      rethrow; // Rethrow the error so it can be handled higher up
    }
  }
}
