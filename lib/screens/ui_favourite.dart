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

  List<Favourite> favItems=[];

  Map<String, bool> filterOptions = {
    'trackName': false,
    'artistName': false,
    'albumName': false,
    'lyrics': false,
  };

  Future<List<Favourite>> getAllFavourites() async{
    favItems = await favouriteService.getAllFavourites();
    return favItems;
  }

  Future<void> showItems() async{
    List<Favourite> allFavs = await favouriteService.getAllFavourites();
    String searchKey = searchController.text;
    setState(() {
      if (searchKey.isEmpty){
        favItems = allFavs;
      }else{
        favItems = allFavs.where((favItem) {
          return favItem.trackData.trackName.toLowerCase().contains(searchKey.toLowerCase()) ||
              favItem.trackData.artistName.toLowerCase().contains(searchKey.toLowerCase()) ||
              favItem.trackData.artistName.toLowerCase().contains(searchKey.toLowerCase()) ||
              favItem.trackData.plainLyrics.toLowerCase().contains(searchKey.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getAllFavourites(),
        builder: (BuildContext context, AsyncSnapshot<List<Favourite>> snapshot){
          if (snapshot.hasData){
            if (snapshot.data!.isEmpty){ // chnaged to isEmpty
              return const Center(child: Text("Favourites is empty!",style: TextStyle(fontSize: 20),),);
            }else{
              return Column(
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                                labelText: 'Search keywords',
                                border: OutlineInputBorder()
                            ),
                            onChanged: (_) async {
                              await showItems();
                            },
                          ),
                        ),
                      ),

                      // IconButton(
                      //   icon: const Icon(Icons.filter_list),
                      //   onPressed: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return AlertDialog(
                      //           title: const Text('Filter Options'),
                      //           content: Column(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               CheckboxListTile(
                      //                 title: const Text('Track Name'),
                      //                 value: filterOptions['trackname'] ?? false, // Ensure non-null value
                      //                 tristate: true,
                      //                 onChanged: (value) {
                      //                   setState(() {
                      //                     filterOptions['trackname'] = value ?? false; // Ensure non-null value
                      //                   });
                      //
                      //                 },
                      //               ),
                      //               CheckboxListTile(
                      //                 title: const Text('Artist Name'),
                      //                 value: filterOptions['artistname'] ?? false, // Ensure non-null value
                      //                 onChanged: (value) {
                      //                   setState(() {
                      //                     filterOptions['artistname'] = value ?? false; // Ensure non-null value
                      //                   });
                      //                 },
                      //               ),
                      //               CheckboxListTile(
                      //                 title: const Text('Album Name'),
                      //                 value: filterOptions['albumname'] ?? false, // Ensure non-null value
                      //                 onChanged: (value) {
                      //                   setState(() {
                      //                     filterOptions['albumname'] = value ?? false; // Ensure non-null value
                      //                   });
                      //                 },
                      //               ),
                      //               CheckboxListTile(
                      //                 title: const Text('Lyrics'),
                      //                 value: filterOptions['lyrics'] ?? false, // Ensure non-null value
                      //                 onChanged: (value) {
                      //                   setState(() {
                      //                     filterOptions['lyrics'] = value ?? false; // Ensure non-null value
                      //                   });
                      //                 },
                      //               ),
                      //             ],
                      //           ),
                      //           actions: [
                      //             TextButton(
                      //               onPressed: () {
                      //                 Navigator.pop(context);
                      //                 //_filterFavourites(searchController.text); // Re-filter after updating options
                      //               },
                      //               child: const Text('Apply'),
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),

                    ],
                  ),

                  const SizedBox(height: 10,),

                  Expanded(
                    child: ListView.builder(
                      itemCount: favItems.length,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.withOpacity(0.2),
                            child: const Icon(Icons.music_note_outlined, color: Colors.blue),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite,color: Colors.red,),
                            onPressed: () async{
                              await favouriteService.deleteTrackData(favItems[index].trackData);
                              setState(() {});
                            },
                          ),
                          title: Text(
                            favItems[index].trackData.trackName,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            "${favItems[index].trackData.artistName} | ${'${(Duration(seconds: favItems[index].trackData.duration.toInt()))}'.split('.')[0].replaceFirst("0:", "")}",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[700],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => UiPlainLyrics(trackData: favItems[index].trackData,) ));
                          },
                        );
                      },
                    ),
                  )

                ],
              );
            }
          } else if(snapshot.hasError){
            return const Center(child: Text('An Error occurred!',style: TextStyle(fontSize: 20),),);
          } else{
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}





class UiFavouritePage extends StatelessWidget {
  const UiFavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
