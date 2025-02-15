class Lyrics {
  final int id;
  final String trackName;
  final String artistName;
  final String albumName;
  final double duration;
  final bool instrumental;
  final String plainLyrics;
  final String? syncedLyrics;

  Lyrics({
    required this.id,
    required this.trackName,
    required this.artistName,
    required this.albumName,
    required this.duration,
    required this.instrumental,
    required this.plainLyrics,
    this.syncedLyrics,
  });

  factory Lyrics.fromJson(Map<String, dynamic> data) {
    return Lyrics(
        id: data["id"],
        trackName: data["trackName"],
        artistName: data["artistName"],
        albumName: data["albumName"],
        duration: data["duration"],
        instrumental: data["instrumental"],
        plainLyrics: data["plainLyrics"],
        syncedLyrics: data["syncedLyrics"],
    );
  }

}
