import 'package:flutter/material.dart';
import 'package:music_democracy/providers/songs_provider.dart';
import 'package:music_democracy/widgets/admin/search_box.dart';
import 'package:music_democracy/widgets/admin/songs_search_builder.dart';
import 'package:provider/provider.dart';

import '../../widgets/admin/songs_by_genre.dart';
import '../../widgets/admin/genre_item.dart';
import '../../models/genres.dart';

class SongsScreen extends StatefulWidget {
  @override
  _SongsScreenState createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  var showByGenre = false;
  var genre;
  bool searching = false;
  final _searchController = TextEditingController();

  void toggleGenres(String genreFrom) {
    setState(() {
      showByGenre = true;
      genre = genreFrom;
    });
  }

  void goBack() {
    setState(() {
      showByGenre = false;
    });
  }

  void searchSongs() {
    if (_searchController.text.isEmpty) return;
    setState(() {
      searching = true;
    });
    //  SharedPrefs().toggleCanvasColor(true);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return searching
        ? Column(
            children: [
              SearchBox(_searchController, searchSongs),
              Flexible(
                  flex: 10,
                  child: SizedBox(
                      child: SongsSearchBuilder(_searchController.text))),
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: (Provider.of<Songs>(context, listen: false)
                              .getSongsBySearch(_searchController.text)
                              .length ==
                          0)
                      ? 170
                      : double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        searching = false;
                      });
                      _searchController.clear();
                      //      SharedPrefs().toggleCanvasColor(false);
                    },
                    child: const Text('Exit Search'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black26,
                      elevation: 10,
                      //             shadowColor: Colors.blue,
                    ),
                  ),
                ),
              )
            ],
          )
        : showByGenre
            ? SongsByGenre(genre, goBack)
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SearchBox(_searchController, searchSongs),
                    Expanded(
                      child: GridView(
                        padding: const EdgeInsets.only(
                            right: 25, left: 25, bottom: 25, top: 15),
                        children: Genres.genres
                            .map((genreData) => GenreItem(
                                  genreData,
                                  Colors.blue,
                                  toggleGenres,
                                ))
                            .toList(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}
