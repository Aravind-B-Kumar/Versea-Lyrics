import 'package:flutter/material.dart';
import 'package:versealyric/database/database.dart';
import 'package:versealyric/database/database_services.dart';
import 'package:versealyric/screens/ui_plain_lyrics.dart';

class UiFavourite extends StatefulWidget {
  const UiFavourite({super.key});

  @override
  State<UiFavourite> createState() => _UiFavouriteState();
}

class _UiFavouriteState extends State<UiFavourite> {
  final FavouriteService favouriteService = FavouriteService();
  final TextEditingController searchController = TextEditingController();

  List<Favourite> favItems = [];

  Map<String, bool> filterOptions = {
    'trackname': true, // Default to true
    'artistname': false,
    'albumname': false,
    'lyrics': false,
  };

  Future<void> showItems() async {
    List<Favourite> allFavs = await favouriteService.getAllFavourites();
    String searchKey = searchController.text.trim();

    List<Favourite> filteredFavs = allFavs;

    if (searchKey.isNotEmpty) {
      filteredFavs = filteredFavs.where((favItem) {
        bool matches = false;

        if (filterOptions['trackname'] == true &&
            favItem.trackName.toLowerCase().contains(searchKey.toLowerCase())) {
          matches = true;
        }
        if (filterOptions['artistname'] == true &&
            favItem.artistName.toLowerCase().contains(searchKey.toLowerCase())) {
          matches = true;
        }
        if (filterOptions['albumname'] == true &&
            favItem.albumName.toLowerCase().contains(searchKey.toLowerCase())) {
          matches = true;
        }
        if (filterOptions['lyrics'] == true &&
            favItem.plainLyrics.toLowerCase().contains(searchKey.toLowerCase())) {
          matches = true;
        }

        return matches;
      }).toList();
    }

    setState(() {
      favItems = filteredFavs;
    });
  }

  void _updateFilterOptions(Map<String, bool> updatedFilters) {
    bool allUnchecked = true;
    updatedFilters.forEach((key, value) {if (value == true && key != 'trackname') {
        allUnchecked = false;
      }
    });

    if (allUnchecked) {
      updatedFilters['trackname'] = true;
    }

    setState(() {
      filterOptions = updatedFilters;
      showItems();
    });
  }

  @override
  void initState() {
    super.initState();
    showItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ... (rest of your build method remains the same)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search keywords',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      showItems();
                    },
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      Map<String, bool> tempFilters = Map.from(filterOptions);
                      return StatefulBuilder(
                        builder: (context, setStateDialog) {
                          return AlertDialog(
                            title: const Text('Filter Options'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CheckboxListTile(
                                  title: const Text('Track Name'),
                                  value: tempFilters['trackname'] ?? false,
                                  onChanged: (value) {
                                    setStateDialog(() {
                                      tempFilters['trackname'] = value ?? false;
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: const Text('Artist Name'),
                                  value: tempFilters['artistname'] ?? false,
                                  onChanged: (value) {
                                    setStateDialog(() {
                                      tempFilters['artistname'] = value ?? false;
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: const Text('Album Name'),
                                  value: tempFilters['albumname'] ?? false,
                                  onChanged: (value) {
                                    setStateDialog(() {
                                      tempFilters['albumname'] = value ?? false;
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: const Text('Lyrics'),
                                  value: tempFilters['lyrics'] ?? false,
                                  onChanged: (value) {
                                    setStateDialog(() {
                                      tempFilters['lyrics'] = value ?? false;
                                    });
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _updateFilterOptions(tempFilters);
                                },
                                child: const Text('Apply'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: favItems.isEmpty
                ? const Center(
              child: Text(
                "Favourites is empty!",
                style: TextStyle(fontSize: 20),
              ),
            )
                : ListView.builder(
              itemCount: favItems.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    child: const Icon(Icons.music_note_outlined,
                        color: Colors.blue),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await favouriteService
                          .deleteTrackData(favItems[index].id);
                      showItems();
                    },
                  ),
                  title: Text(
                    favItems[index].trackName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${favItems[index].artistName} | ${'${(Duration(seconds: favItems[index].duration.toInt()))}'.split('.')[0].replaceFirst("0:", "")}",
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            UiPlainLyrics(trackData: favItems[index])));
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