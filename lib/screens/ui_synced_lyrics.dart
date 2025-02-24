import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lrc/lrc.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:versealyric/database/database.dart';
import 'package:versealyric/screens/ui_plain_lyrics.dart';

import '../providers/theme_provider.dart';

class UiSyncedLyrics extends StatefulWidget {
  const UiSyncedLyrics({super.key, required this.trackData});

  final Favourite trackData;

  @override
  State<UiSyncedLyrics> createState() => _UiSyncedLyricsState();
}

class _UiSyncedLyricsState extends State<UiSyncedLyrics> {
  static const _currentPage = 'synced';

  late Lrc parsedLrc;
  double currentTime = 0;
  int activeLyricIndex = 0;
  bool isPlaying = false;
  late String currentLyric;
  final GlobalKey _listViewKey = GlobalKey();

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  int initialScrollIndex = 0;

  @override
  void initState() {
    super.initState();
    parsedLrc = widget.trackData.syncedLyrics!.toLrc();
    currentLyric = parsedLrc.lyrics.first.lyrics;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToActiveLyric(initialScrollIndex); // Scroll to initial index
    });
  }

  void _scrollToActiveLyric(int activeIndex) {
    if (itemScrollController.isAttached) {
      itemScrollController.scrollTo(
        index: activeIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.35, // Centers the item
      );
    }
  }

  void _updateLyric(double time) {
    int newActiveIndex = -1;
    for (int i = parsedLrc.lyrics.length - 1; i >= 0; i--) {
      if (time >= parsedLrc.lyrics[i].timestamp.inSeconds) {
        if (currentLyric != parsedLrc.lyrics[i].lyrics) {
          setState(() {
            currentLyric = parsedLrc.lyrics[i].lyrics;
            activeLyricIndex = i; // Update active index immediately
          });
          _scrollToActiveLyric(i); // Scroll to the new active index
        }
        newActiveIndex = i;
        break;
      }
    }
  }

  void _togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      _startPlayback();
    }
  }

  void _startPlayback() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (isPlaying) {
        setState(() {
          if (currentTime < parsedLrc.lyrics.last.timestamp.inSeconds) {
            currentTime += 1;
            _updateLyric(currentTime);
          } else {
            currentTime = 0;
            isPlaying = false;
            _updateLyric(currentTime);
          }
        });
      }
      return isPlaying;
    });
  }

  void _onSeek(double value) {
    double roundedValue = value.roundToDouble();
    setState(() {
      currentTime = roundedValue.clamp(0.0, parsedLrc.lyrics.last.timestamp.inSeconds.toDouble());
      _updateLyric(currentTime);
    });
  }

  void _onLyricTap(Duration timestamp) {
    setState(() {
      currentTime = timestamp.inSeconds.toDouble();
      _updateLyric(currentTime);
      isPlaying = true;
      _startPlayback();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeData;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => UiPlainLyrics(trackData: widget.trackData)),
              );
            },
            child: const Text('Plain'),
          ),
          TextButton(
            onPressed: () {
              if (_currentPage == 'synced') {
                return;
              }
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => UiSyncedLyrics(trackData: widget.trackData)),
              );
            },
            child: const Text('Synced'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Track Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Title: ${widget.trackData.trackName}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Artist: ${widget.trackData.artistName}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Album: ${widget.trackData.albumName}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Instrumental: ${widget.trackData.instrumental}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Duration: ${widget.trackData.duration}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: widget.trackData.syncedLyrics == null || parsedLrc.lyrics.isEmpty
          ? const Center(
        child: Text(
          'Synced Lyrics not available!',
          style: TextStyle(fontSize: 20),
        ),
      )
          : Column(
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
            child: ScrollablePositionedList.builder(
              key: _listViewKey,
              itemCount: parsedLrc.lyrics.length,
              itemBuilder: (context, index) {
                final lyric = parsedLrc.lyrics[index];
                bool isActive = false;

                if (index < parsedLrc.lyrics.length - 1) {
                  isActive = currentTime >= lyric.timestamp.inSeconds &&
                      currentTime < parsedLrc.lyrics[index + 1].timestamp.inSeconds;
                } else {
                  isActive = currentTime >= lyric.timestamp.inSeconds;
                }
                return ListTile(
                  title: Text(
                    lyric.lyrics,
                    style: TextStyle(
                        fontSize: isActive ? 24 : 20,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        color: isActive ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color),
                  ),
                  onTap: () => _onLyricTap(lyric.timestamp),
                );
              },
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              initialScrollIndex: initialScrollIndex,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Slider(
                  value: currentTime,
                  min: 0,
                  max: parsedLrc.lyrics.last.timestamp.inSeconds.toDouble(),
                  onChanged: _onSeek,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(Duration(seconds: currentTime.toInt()))),
                    Text(_formatDuration(parsedLrc.lyrics.last.timestamp)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            iconSize: 50,
            onPressed: _togglePlay,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
