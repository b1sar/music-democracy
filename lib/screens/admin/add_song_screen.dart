import 'package:flutter/material.dart';
import 'package:music_democracy/models/song.dart';
import 'package:music_democracy/providers/songs_provider.dart';
import 'package:music_democracy/util/utility.dart';
import 'package:music_democracy/widgets/admin/genre_check_box.dart';
import 'package:provider/provider.dart';
import '../../widgets/admin/song_text_input.dart';
import '../../models/genres.dart';

class AddSongScreen extends StatefulWidget {
  static const routeName = '/add-song';

  @override
  _AddSongScreenState createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final List<bool> isChecked = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  final _songFormKey = GlobalKey<FormState>();

  String finalSongName;

  String finalSongArtist;

  bool isValid = false;

  void toggleChecked(int index) {
    setState(() {
      isChecked[index] = !isChecked[index];
    });
  }

  void setSongValues(String value, String hint) {
    if (hint == 'Song Name')
      finalSongName = value;
    else if (hint == 'Song Artist') finalSongArtist = value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(10, 5, 27, 0.9),
              Color.fromRGBO(33, 98, 131, 0.9),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Icon(Icons.add),
              ),
            ],
            title: Text('Add New Song'),
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _songFormKey,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SongTextInput('Song Name', setSongValues),
                    SongTextInput('Song Artist', setSongValues),
                    Text(
                      'Song Name & Artist',
                      style: TextStyle(color: Colors.grey.shade300),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GenreCheckBox(Genres.genres[0], toggleChecked, 0),
                              GenreCheckBox(Genres.genres[1], toggleChecked, 1),
                              GenreCheckBox(Genres.genres[2], toggleChecked, 2),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GenreCheckBox(Genres.genres[3], toggleChecked, 3),
                              GenreCheckBox(Genres.genres[4], toggleChecked, 4),
                              GenreCheckBox(Genres.genres[5], toggleChecked, 5),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GenreCheckBox(Genres.genres[6], toggleChecked, 6),
                              GenreCheckBox(Genres.genres[7], toggleChecked, 7),
                              GenreCheckBox(Genres.genres[8], toggleChecked, 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Pick Song Genres',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    Container(
                      width: 190,
                      padding: const EdgeInsets.only(top: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            isValid = _songFormKey.currentState.validate();
                            if (isValid) {
                              _songFormKey.currentState.save();
                              List<String> songGenres = [];
                              for (int i = 0; i < isChecked.length; i++) {
                                if (isChecked[i] == true)
                                  songGenres.add(Genres.genres[i]);
                              }

                              try {
                                Provider.of<Songs>(context, listen: false)
                                    .addSong(Song(
                                  finalSongName,
                                  finalSongArtist,
                                  songGenres,
                                ));
                                isChecked.forEach((element) {
                                  element = false;
                                });
                                showSnackBarError(context, 'Song added');
                                Navigator.of(context).pop();
                              } catch (error) {
                                print('error while adding');
                                showSnackBarError(context, 'Error while adding');
                              }
                              setState(() {
                                isChecked.forEach((element) {
                                  element = false;
                                });
                              });
                              print(finalSongName + finalSongArtist);
                              print(isChecked);
                            }
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Add Song',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.pink.shade200,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
