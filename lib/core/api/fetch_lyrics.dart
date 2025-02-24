import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/lyrics_model.dart';

const String apiUrl = 'https://lrclib.net/api/search';

Future<List<Lyrics>> getLyrics(
    {String? q,
    String? trackName,
    String? artistName,
    String? albumName}) async {
  final Map<String, String> queryParams = {};

  if (q != null) {
    queryParams['q'] = q;
  }
  if (trackName != null) {
    queryParams['track_name'] = trackName;
  }
  if (artistName != null) {
    queryParams['artist_name'] = artistName;
  }
  if (albumName != null) {
    queryParams['album_name'] = albumName;
  }

  final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

  try {
    final response = await http.get(uri,headers: {"User-Agent":"Versea Lyric"},);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      final List<Lyrics> results = [];
      for (var record in data) {
        if (record["plainLyrics"] != null) {
          results.add(Lyrics.fromJson(record));
        }
      }
      return results;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}
