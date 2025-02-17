
import 'package:hive_flutter/hive_flutter.dart';

import '../models/lyrics_model.dart';

part 'database.g.dart';

@HiveType(typeId: 0)
class Favourite extends HiveObject {
  @HiveField(0)
  LyricsHive trackData;

  Favourite({required this.trackData});
}

@HiveType(typeId: 1)
class History extends HiveObject{
  @HiveField(0)
  String searchWord;

  History({required this.searchWord});
}


@HiveType(typeId: 2)
class LyricsHive {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String trackName;

  @HiveField(2)
  final String artistName;

  @HiveField(3)
  final String albumName;

  @HiveField(4)
  final double duration;

  @HiveField(5)
  final bool instrumental;

  @HiveField(6)
  final String plainLyrics;

  @HiveField(7)
  final String? syncedLyrics;

  LyricsHive({
    required this.id,
    required this.trackName,
    required this.artistName,
    required this.albumName,
    required this.duration,
    required this.instrumental,
    required this.plainLyrics,
    this.syncedLyrics,
  });

  factory LyricsHive.fromJson(Lyrics trackData) => LyricsHive(
    id: trackData.id,
    trackName: trackData.trackName,
    artistName: trackData.artistName,
    albumName: trackData.albumName,
    duration: trackData.duration, // Handle num to double
    instrumental: trackData.instrumental,
    plainLyrics: trackData.plainLyrics,
    syncedLyrics: trackData.syncedLyrics,
  );

}





//
// import 'package:hive_flutter/hive_flutter.dart';
//
// import '../models/lyrics_model.dart';
//
// part 'database.g.dart';
//
// @HiveType(typeId: 0)
// class Favourite extends HiveObject {
//   @HiveField(0)
//   int id;
//
//   @HiveField(1)
//   String plainLyrics;
//
//   @HiveField(2,defaultValue: null)
//   String? syncedLyrics;
//
//   Favourite({required this.id,required this.plainLyrics, this.syncedLyrics});
//
//   factory Favourite.fromJson(Lyrics trackData) {
//     return Favourite(
//         id: trackData.id,
//         plainLyrics: trackData.plainLyrics,
//         syncedLyrics: trackData.syncedLyrics
//     );
//   }
// }
//
// @HiveType(typeId: 1)
// class History extends HiveObject{
//   @HiveField(0)
//   String searchWord;
//
//   History({required this.searchWord});
// }
//
// //-------------------------------------------------------
//
// class FavouriteService{
//   final String _boxName = 'favourite';
//
//   Future<Box<Favourite>> get _box async => await Hive.openBox<Favourite>(_boxName);
//
//   Future<void> addItem(Favourite favTrackData) async{
//     var box = await _box;
//     await box.add(favTrackData);
//   }
//
//   Future<List<Favourite>> getAllFavourites() async {
//     var box = await _box;
//     return box.values.toList();
//   }
//
//   Future<void> deleteItem(int index) async {
//     var box = await _box;
//     await box.deleteAt(index);
//   }
//
//
// }
//
//
//
//


