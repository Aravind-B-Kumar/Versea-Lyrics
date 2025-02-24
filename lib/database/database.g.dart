// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouriteAdapter extends TypeAdapter<Favourite> {
  @override
  final int typeId = 0;

  @override
  Favourite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favourite(
      id: fields[0] as int,
      trackName: fields[1] as String,
      artistName: fields[2] as String,
      albumName: fields[3] as String,
      duration: fields[4] as double,
      instrumental: fields[5] as bool,
      plainLyrics: fields[6] as String,
      syncedLyrics: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Favourite obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.trackName)
      ..writeByte(2)
      ..write(obj.artistName)
      ..writeByte(3)
      ..write(obj.albumName)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.instrumental)
      ..writeByte(6)
      ..write(obj.plainLyrics)
      ..writeByte(7)
      ..write(obj.syncedLyrics);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemeAdapter extends TypeAdapter<Theme> {
  @override
  final int typeId = 1;

  @override
  Theme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Theme(
      isDarkTheme: fields[0] == null ? false : fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Theme obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.isDarkTheme);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
