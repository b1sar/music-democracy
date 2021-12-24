import 'package:flutter/material.dart';
import 'package:music_democracy/providers/lobbies_provider.dart';
import 'package:music_democracy/providers/poll_provider.dart';
import 'package:music_democracy/providers/songs_provider.dart';
import 'package:music_democracy/util/utility.dart';
import 'package:provider/provider.dart';

class SongsSearchBuilder extends StatefulWidget {
  final String searchInput;

  SongsSearchBuilder(this.searchInput);
  @override
  _SongsSearchBuilderState createState() => _SongsSearchBuilderState();
}

class _SongsSearchBuilderState extends State<SongsSearchBuilder> {
  Future<void> _showMyDialog(String name, String artist) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete song:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontFamily: 'Lexend',
              )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  artist + ' - ' + name + '\n',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Are you sure you want to delete this song?',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    //        fontWeight: FontWeight.bold,
                  ),
                ),
                //            Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Provider.of<Songs>(context, listen: false).deleteSong(
                  name,
                  artist,
                );
                Navigator.of(context).pop();
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              child: Text(
                'No',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
    return (Provider.of<Songs>(context, listen: false)
                .getSongsBySearch(widget.searchInput)
                .length ==
            0)
        ? Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            child: Text(
              'No songs found!',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 26,
              ),
              textAlign: TextAlign.center,
            ),
          )
        : Consumer<Songs>(
            builder: (ctx, songsData, child) => ListView.builder(
                itemCount:
                    songsData.getSongsBySearch(widget.searchInput).length,
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 0.1,
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Center(
                      child: InkWell(
                        onLongPress: () {
                          _showMyDialog(
                            songsData
                                .getSongsBySearch(widget.searchInput)[i]
                                .name,
                            songsData
                                .getSongsBySearch(widget.searchInput)[i]
                                .artist,
                          );
                          /*        Provider.of<Songs>(context, listen: false).deleteSong(
                        songsData.getSongsByGenre(widget.genre)[i].name,
                        songsData.getSongsByGenre(widget.genre)[i].artist, 
                      ) */
                        },
                        child: ListTile(
                          key: ValueKey(
                            songsData
                                    .getSongsBySearch(widget.searchInput)[i]
                                    .artist +
                                ' - ' +
                                songsData
                                    .getSongsBySearch(widget.searchInput)[i]
                                    .name,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.black26,
                            child: Icon(
                              Icons.music_note,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            songsData
                                    .getSongsBySearch(widget.searchInput)[i]
                                    .artist +
                                ' - ' +
                                songsData
                                    .getSongsBySearch(widget.searchInput)[i]
                                    .name,
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 18,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add_circle_outline,
                                    color: Colors.blue),
                                onPressed: () {
                                  if (Provider.of<Lobbies>(context,
                                              listen: false)
                                          .getLobbySongsPerPoll ==
                                      0) {
                                    showSnackBarError(context, 'Create a lobby first!');
                                  } else if (Provider.of<Lobbies>(context,
                                              listen: false)
                                          .getLobbySongsPerPoll ==
                                      Provider.of<Polls>(context, listen: false)
                                          .getCurrentPollSize) {
                                    showSnackBarError(context, 'Poll is full!');
                                  } else {
                                    Provider.of<Polls>(context, listen: false)
                                        .addToPoll(songsData.getSongsBySearch(
                                            widget.searchInput)[i]);
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    showSnackBarError(context, 'Song added to poll!');
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
