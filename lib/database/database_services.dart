import 'package:hive/hive.dart';
import 'package:versealyric/database/database.dart';
import 'package:collection/collection.dart';


class FavouriteService{
  final String _boxName = 'favourite';

  Future<Box<Favourite>> get _box async => await Hive.openBox<Favourite>(_boxName);

  Future<void> addItem(LyricsHive trackData) async { // Corrected
    var box = await _box;

    await deleteTrackData(trackData);
    final favourite = Favourite(trackData: trackData); // Corrected
    await box.add(favourite);
  }

  // Future<void> addItem(LyricsHive trackData) async{
  //   var box = await _box;
  //   await box.add(Favourite(trackData: trackData));
  // }

  Future<List<Favourite>> getAllFavourites() async {
    var box = await _box;
    return box.values.toList();
  }

  Future<void> deleteAtIndex(int index) async {
    var box = await _box;
    await box.deleteAt(index);
  }

  Future<void> deleteTrackData(LyricsHive trackData) async {
    var box = await _box;
    final favouriteToDelete = box.values.firstWhereOrNull((f) => f.trackData.id == trackData.id);
    await favouriteToDelete?.delete();
  }

}

