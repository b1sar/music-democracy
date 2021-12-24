import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_democracy/models/lobby.dart';
import 'package:music_democracy/models/sharedPrefs.dart';
import 'package:music_democracy/providers/lobbies_provider.dart';
import 'package:music_democracy/widgets/admin/lobby_duration_radio_row.dart';
import 'package:music_democracy/widgets/admin/lobby_song_number.dart';
import 'package:music_democracy/widgets/admin/lobby_text_input.dart';
import 'package:music_democracy/util/utility.dart';
import 'package:provider/provider.dart';

class CreateLobbyScreen extends StatefulWidget {
  static const routeName = '/create-lobby';

  @override
  _CreateLobbyScreenState createState() => _CreateLobbyScreenState();
}

class _CreateLobbyScreenState extends State<CreateLobbyScreen> {
  final _lobbyCreationFormKey = GlobalKey<FormState>();

  String finalLobbyName;

  int finalLobbyCapacity;

  String finalLobbyCode;

  bool isValid;

  int lobbyDuration = 0;

  int lobbySongsTotal = 0;

  bool isLoading = false;

  void setLobbyInfo(String value, String hint) {
    if (hint == 'Lobby Name')
      finalLobbyName = value;
    else if (hint == 'Lobby Capacity')
      finalLobbyCapacity = int.parse(value);
    else if (hint == 'Lobby Code') finalLobbyCode = value;
  }

  void _tryLobbyCreate() async {
    isValid = _lobbyCreationFormKey.currentState.validate();
    if (lobbyDuration == 0) {
      showSnackBarError(context, 'Please provide a lobby duration');
    } else if (lobbySongsTotal == 0) {
      showSnackBarError(context, 'Please set the number of songs');
    } else if (isValid) {
      _lobbyCreationFormKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      bool codeExists = false;
      try {
        await FirebaseFirestore.instance
            .collection('lobbyCodes')
            .get()
            .then((query) => {
                  query.docs.forEach((doc) {
                    print(finalLobbyCode);
                    print(doc.id);
                    if (doc.id == finalLobbyCode) {
                      codeExists = true;
                    }
                  })
                })
            .whenComplete(() async {
          if (codeExists) {
            showSnackBarError(context, 'Entered lobby code already exists!');
            setState(() {
              isLoading = false;
            });
            return;
          } else {
            await FirebaseFirestore.instance
                .collection('lobbyCodes')
                .doc(finalLobbyCode)
                .set({
              'lobbyCodeAsAdminId': SharedPrefs().userId,
            });
          }
        });
      } catch (error) {
        print(error.message);
        throw error;
      }
      if (codeExists) return;
      Provider.of<Lobbies>(context, listen: false)
          .createLobby(Lobby(
        name: finalLobbyName,
        capacity: finalLobbyCapacity,
        duration: lobbyDuration,
        songsPerPoll: lobbySongsTotal,
        lobbyCode: finalLobbyCode,
        ownerId: SharedPrefs().userId
      ))
          .whenComplete(() {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lobby Created!',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
        Navigator.of(context).pop();
      });
      print(finalLobbyName);
      print(finalLobbyCapacity);
      print(lobbyDuration);
      print(lobbySongsTotal);
    }
  }

  void setLobbyDuration(int duration) {
    lobbyDuration = duration;
  }

  void setSongsTotal(int totalSongs) {
    lobbySongsTotal = totalSongs;
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
            title: Text('Create New Lobby'),
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _lobbyCreationFormKey,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    LobbyTextInput('Lobby Name', setLobbyInfo),
                    LobbyTextInput('Lobby Capacity', setLobbyInfo),
                    LobbyTextInput('Lobby Code', setLobbyInfo),
                    Text(
                      'Lobby Name & Capacity',
                      style: TextStyle(color: Colors.grey.shade300),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        margin: EdgeInsets.only(top: 15, bottom: 25),
                        width: double.infinity,
                        child: LobbyDurationRadioButtonRow(setLobbyDuration)),
                    Text(
                      'Lobby Voting Duration',
                      style: TextStyle(color: Colors.grey.shade300),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        margin: EdgeInsets.only(top: 15, bottom: 25),
                        width: double.infinity,
                        child: LobbySongNumberRow(setSongsTotal)),
                    Text(
                      'Number of songs per poll',
                      style: TextStyle(color: Colors.grey.shade300),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 18),
                      width: 200,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue.shade200,
                            Colors.pink.shade200,
                          ],
                        ),
                      ),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : TextButton.icon(
                              onPressed: _tryLobbyCreate,
                              icon: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              label: Text(
                                'CREATE LOBBY',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Lexend',
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
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
