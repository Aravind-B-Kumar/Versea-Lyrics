import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versealyric/core/themes/themes.dart';
import '../providers/theme_provider.dart';

class UiInfo extends StatefulWidget {
  const UiInfo({super.key});

  @override
  State<UiInfo> createState() => _UiInfoState();
}

class _UiInfoState extends State<UiInfo> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    bool getThemeMode(){
      return themeProvider.themeData==darkTheme ?true :false;
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(getThemeMode() ?'Disable Dark Mode' :'Enable Dark Mode'),
                secondary: Icon(getThemeMode() ?Icons.light_mode :Icons.dark_mode ),
                value: getThemeMode(), //TODO: store in db
                onChanged: (newValue){
                  setState(() {
                    themeProvider.toggleTheme();
                  });
                },
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.blueGrey,
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
