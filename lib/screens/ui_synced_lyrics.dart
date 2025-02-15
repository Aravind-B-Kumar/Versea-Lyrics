import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:versealyric/models/lyrics_model.dart';
import 'package:versealyric/screens/ui_plain_lyrics.dart';

class UiSyncedLyrics extends StatefulWidget {
  const UiSyncedLyrics({super.key,required this.trackData});

  final Lyrics trackData;

  @override
  State<UiSyncedLyrics> createState() => _UiSyncedLyricsState();
}

class _UiSyncedLyricsState extends State<UiSyncedLyrics> {

  static const _currentPage='synced';
  double _fontSize = 20.0;

  void _increaseFontSize() {
    if(_fontSize>=30){
      return;
    }
    setState(() {
      _fontSize += 1.0;
    });
  }

  void _decreaseFontSize() {
    if(_fontSize<=16){
      return;
    }
    setState(() {
      _fontSize -= 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {

    void _showInfo() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // Ensure the dialog wraps its content
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text to the start
                children: [
                  const Text(
                    'Track Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10), // Add spacing
                  Text(
                    'Title: ${widget.trackData.trackName}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 8), // Add spacing
                  Text(
                    'Artist: ${widget.trackData.artistName}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 8), // Add spacing
                  Text(
                    'Album: ${widget.trackData.albumName}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 8), // Add spacing
                  Text(
                    'Instrumental: ${widget.trackData.instrumental}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 8), // Add spacing
                  Text(
                    'Duration: ${widget.trackData.duration}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 16), // Add spacing

                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => UiPlainLyrics(trackData: widget.trackData))
              );
            },
            child: const Text('Plain'),
          ),

          TextButton(
            onPressed: (){
              if(_currentPage=='synced'){
                return;
              }
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => UiSyncedLyrics(trackData: widget.trackData))
              );
            },
            child: const Text('Synced'),
          ),

          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfo(),
          )
        ],
      ),

      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    widget.trackData.trackName,
                    style: GoogleFonts.timmana(fontSize: 25),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.trackData.plainLyrics,
                      style: TextStyle(fontSize: _fontSize),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Floating buttons on top of the content
          Positioned(
            bottom: 16.0 , // Distance from the bottom
            right: 16.0, // Distance from the right
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum space
              children: [
                FloatingActionButton(
                  onPressed: (){
                    //TODO

                  },
                  mini: true, // Makes the button smaller
                  child: const Icon(Icons.favorite_border),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: _increaseFontSize,
                  mini: true, // Makes the button smaller
                  child: const Icon(Icons.add),
                ),
                // Space between the buttons
                FloatingActionButton(
                  onPressed: _decreaseFontSize,
                  mini: true, // Makes the button smaller
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
