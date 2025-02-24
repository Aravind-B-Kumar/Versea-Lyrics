import 'package:hive/hive.dart';
import 'package:versealyric/database/database.dart';
import 'package:collection/collection.dart';
import 'package:versealyric/models/lyrics_model.dart';


class FavouriteService{
  final String _boxName = 'favourite';

  Future<Box<Favourite>> get _box async => await Hive.openBox<Favourite>(_boxName);

  Future<void> addItem(Lyrics trackData) async { // Corrected
    var box = await _box;
    await deleteTrackData(trackData.id);
    await box.add(Favourite.fromTrackData(trackData));
  }

  Future<List<Favourite>> getAllFavourites() async {
    var box = await _box;
    return box.values.toList().reversed.toList();
  }

  Future<void> deleteAtIndex(int index) async {
    var box = await _box;
    await box.deleteAt(index);
  }

  Future<void> deleteTrackData(int id) async {
    var box = await _box;
    final key = box.keys.firstWhereOrNull((k) {
      final favourite = box.get(k); // Get the Favourite object by key
      return favourite?.id == id; // Check if the IDs match
    });
    if (key!=null) {
      await box.delete(key);
    }
  }

}

class ThemeService{
  final String _boxName = 'theme';

  Future<Box<Theme>> get _box async => await Hive.openBox<Theme>(_boxName);

  Future<bool> getTheme() async {
    final box = await _box;
    if (box.isEmpty){
      await box.add(Theme(isDarkTheme: false));
    }
    return box.values.first.isDarkTheme;
  }

  Future<void> toggleTheme() async {
    final box = await _box;
    if (box.isEmpty){
      await box.add(Theme(isDarkTheme: false));
    }
    var theme = box.values.first;
    theme.isDarkTheme = !theme.isDarkTheme;
    await theme.save();
    }
}

