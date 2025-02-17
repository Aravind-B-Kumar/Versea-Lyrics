import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:versealyric/database/database.dart';
import 'package:versealyric/screens/splash_screen.dart';

import 'providers/theme_provider.dart';
import 'core/themes/themes.dart';

void main() async{

  await Hive.initFlutter();
  Hive.registerAdapter(FavouriteAdapter());
  Hive.registerAdapter(HistoryAdapter());
  Hive.registerAdapter(LyricsHiveAdapter());

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(lightTheme),
      child: const VerseaLyric(),
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

}


class VerseaLyric extends StatelessWidget {
  const VerseaLyric({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      home: const SplashScreen(),
    );
  }
}


