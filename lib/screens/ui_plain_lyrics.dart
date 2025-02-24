import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:versealyric/database/database.dart';

import 'ui_synced_lyrics.dart';

class UiPlainLyrics extends StatefulWidget {
  const UiPlainLyrics({super.key, required this.trackData});

  final Favourite trackData;

  @override
  State<UiPlainLyrics> createState() => _UiPlainLyricsState();
}

class _UiPlainLyricsState extends State<UiPlainLyrics> {

  double _fontSize = 20.0;
  static const _currentPage = 'plain';
  IconData copyButtonIcon = Icons.copy;

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


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: (){
              if(_currentPage=='plain'){
                return;
              }
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => UiPlainLyrics(trackData: widget.trackData))
              );
            },
            child: const Text('Plain'),
          ),

          TextButton(
            onPressed: widget.trackData.syncedLyrics==null
                ?null
                :(){
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
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
                    Clipboard.setData(ClipboardData(text: widget.trackData.plainLyrics)).then((_) {
                      setState(() {
                        copyButtonIcon = Icons.check;
                        });
                      Future.delayed(const Duration(seconds: 2), (){
                        setState(() {
                          copyButtonIcon = Icons.copy;
                        });
                      });
                    });
                  },
                  mini: true,
                  heroTag: 'copy', // Makes the button smaller
                  child: Icon(copyButtonIcon),
                ),

                FloatingActionButton(
                  onPressed: () {
                    if(_fontSize>=30){
                      return;
                    }
                    setState(() {
                      _fontSize += 1.0;
                    });
                  },
                  mini: true,
                  heroTag: '+', // Makes the button smaller
                  child: const Icon(Icons.add),
                ),
                 // Space between the buttons
                FloatingActionButton(
                  onPressed: () {
                    if(_fontSize<=16){
                      return;
                    }
                    setState(() {
                      _fontSize -= 1.0;
                    });
                  },
                  mini: true,
                  heroTag: '-', // Makes the button smaller
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