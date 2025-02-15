import 'package:flutter/material.dart';
import 'package:versealyric/core/api/fetchLyrics.dart';
import 'package:versealyric/models/lyrics_model.dart';
import 'package:versealyric/screens/ui_plain_lyrics.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       body: Column(),
//     );
//   }
// }

// import 'package:provider/provider.dart';
// import '../providers/theme_provider.dart';
// final themeProvider = Provider.of<ThemeProvider>(context); // above return scaffold
// ElevatedButton(
// onPressed: () {
// themeProvider.toggleTheme(); //
// },
// child: const Text('Toggle Theme'),
// )

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController artistNameController = TextEditingController();
  bool _isLoading = false;
  List<Lyrics> _searchResults = [];

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Title field should not be empty!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.info_outline),
      //       onPressed: _showInfoDialog,
      //     ),
      //   ],
      // ),

      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: artistNameController,
              decoration: const InputDecoration(
                labelText: 'Artist Name (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {

                  if (_isLoading){
                    return;
                  }

                  if (titleController.text == "") {
                    _showInfoDialog();
                  }

                  setState(() {
                    _isLoading = true;
                  });

                  _searchResults = artistNameController.text.isEmpty
                      ? await getLyrics(q: titleController.text)
                      : await getLyrics(
                          trackName: titleController.text,
                          artistName: artistNameController.text);

                  setState(() {
                    _isLoading = false;
                  });

                  if (_searchResults.isEmpty){
                    if (context.mounted) {
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No results found!",style: TextStyle(color: Colors.black),),
                            backgroundColor: Colors.red,
                            duration: Duration(milliseconds: 800),
                            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
                          )
                      );
                    }
                  }

                },
                child: const Text('Search'),
              ),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    titleController.clear();
                    artistNameController.clear();
                    setState(() {
                      _isLoading = false;
                      _searchResults = [];
                    });
                  },
                  child: const Text('Clear')),
            ],
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final item = _searchResults[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(0.2),
                              child: const Icon(Icons.music_note_outlined, color: Colors.blue),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.favorite_border),
                              onPressed: (){
                                //TODO
                              },
                            ),
                            title: Text(
                              item.trackName,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              "${item.artistName} | ${'${(Duration(seconds: item.duration.toInt()))}'.split('.')[0].replaceFirst("0:", "")}",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[700],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => UiPlainLyrics(trackData: item,) ));
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
