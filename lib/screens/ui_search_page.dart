import 'package:flutter/material.dart';
import 'package:versealyric/core/api/fetch_lyrics.dart';
import 'package:versealyric/database/database.dart';
import 'package:versealyric/models/lyrics_model.dart';
import 'package:versealyric/screens/ui_plain_lyrics.dart';

import '../database/database_services.dart';

class UiSearchPage extends StatefulWidget {
  const UiSearchPage({super.key});

  @override
  State<UiSearchPage> createState() => _UiSearchPageState();
}

class _UiSearchPageState extends State<UiSearchPage> with AutomaticKeepAliveClientMixin {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController artistNameController = TextEditingController();
  final FavouriteService favouriteService = FavouriteService();
  bool _isLoading = false;
  List<Lyrics> _searchResults = [];
  List<Favourite> allFavs = [];

  @override
  void initState() {
    super.initState();
    fetchAllFavs();
  }

  @override
  bool get wantKeepAlive => true;

  void _showInfoDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
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

  Future<void> fetchAllFavs() async{
    allFavs = await favouriteService.getAllFavourites();
  }

  bool isFavourite(int id) {
    return allFavs.any((favItem) => favItem.id == id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(

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

                  if (titleController.text.isEmpty) {

                    if (artistNameController.text.isEmpty) {
                      _showInfoDialog('Title field should not be empty!');
                    } else{
                      _showInfoDialog('Enter artist name in the Title field to search.');
                    }
                    return;
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
                              icon: isFavourite(item.id) ? const Icon(Icons.favorite,color: Colors.red,) : const Icon(Icons.favorite_border),
                              onPressed: () async {
                                if (isFavourite(item.id)) { // Check if already favorite
                                  await favouriteService.deleteTrackData(item.id); // Remove item
                                } else {
                                  await favouriteService.addItem(item); // Add item
                                }
                                await fetchAllFavs();
                                setState(() {});
                              },
                            ),

                            title: Text(
                              item.trackName,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                              "${item.artistName} | ${'${(Duration(seconds: item.duration.toInt()))}'.split('.')[0].replaceFirst("0:", "")}",
                              style: const TextStyle(fontSize: 14.0,),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => UiPlainLyrics(trackData: Favourite.fromTrackData(item),) ));
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
