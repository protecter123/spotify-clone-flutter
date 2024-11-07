import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlayerScreen extends StatefulWidget {
  final List<dynamic> songs;
  final int initialIndex;

  const PlayerScreen({
    super.key,
    required this.songs,
    required this.initialIndex,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = true;
  Duration _currentPosition = Duration.zero;
  Duration _songDuration = Duration.zero;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    currentIndex = widget.initialIndex;
    _setupAudioPlayer();
  }

  Future<void> _setupAudioPlayer() async {
  final currentSong = widget.songs[currentIndex];
  try {
    final url = currentSong['url'] ?? ''; // Fallback to empty string if URL is null
    if (url.isNotEmpty) {
      await _audioPlayer.setUrl(url);
      _audioPlayer.play();  // Start playing immediately after setting the URL
      setState(() {
        _songDuration = _audioPlayer.duration ?? Duration.zero;
      });
      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _currentPosition = position;
        });
      });
    } else {
      // Handle error case, e.g. show a message
      print('URL is null or empty');
    }
  } catch (e) {
    print("Error loading audio: $e");
  }
}

  void _togglePlayPause() {
    setState(() {
      if (isPlaying) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.play();
      }
      isPlaying = !isPlaying;
    });
  }

  void _playNextSong() {
    if (currentIndex < widget.songs.length - 1) {
      setState(() {
        currentIndex++;
      });
      _playCurrentSong();
    }
  }

  void _playPreviousSong() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _playCurrentSong();
    }
  }

  Future<void> _playCurrentSong() async {
    final currentSong = widget.songs[currentIndex];
    try {
      final url = currentSong['url'] ?? ''; // Fallback to empty string if URL is null
      if (url.isNotEmpty) {
        await _audioPlayer.setUrl(url);
        _audioPlayer.play();
        setState(() {
          isPlaying = true;
          _songDuration = _audioPlayer.duration ?? Duration.zero;
          _currentPosition = Duration.zero;
        });
      } else {
        // Handle error case, e.g. show a message
        print('URL is null or empty');
      }
    } catch (e) {
      print("Error playing current song: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.songs[currentIndex];

    // Fallback for missing values
    final songName = currentSong['title'] ?? 'Unknown Song';
    final artistName = currentSong['artist'] ?? 'Unknown Artist';
    final bannerUrl = currentSong['coverImageUrl'] ?? 'default_banner_url_here'; // Replace with a default URL if necessary

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Top bar with back button and title
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    "RECOMMENDED FOR YOU",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Banner image
            CachedNetworkImage(
              imageUrl: bannerUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Song Name and Artist Name
            Text(
              songName,
              style: GoogleFonts.roboto(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              artistName,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Progress bar
            Slider(
              min: 0.0,
              max: _songDuration.inSeconds.toDouble(),
              value: _currentPosition.inSeconds.toDouble().clamp(0, _songDuration.inSeconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _audioPlayer.seek(Duration(seconds: value.toInt()));
                });
              },
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
            ),

            // Time labels for progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_currentPosition),
                    style: GoogleFonts.roboto(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    _formatDuration(_songDuration),
                    style: GoogleFonts.roboto(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Playback controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  iconSize: 36,
                  onPressed: _playPreviousSong,
                ),
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                      size: 36,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  iconSize: 36,
                  onPressed: _playNextSong,
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Format the Duration to mm:ss format
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
