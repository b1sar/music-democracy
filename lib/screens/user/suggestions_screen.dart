import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_democracy/models/sharedPrefs.dart';
import 'package:music_democracy/providers/users_provider.dart';
import 'package:music_democracy/widgets/user/like_counter.dart';

import 'package:provider/provider.dart';

class SuggestionsScreen extends StatelessWidget {
  final bool isAdmin;
  SuggestionsScreen(this.isAdmin);
  final _suggestionController = TextEditingController();
  String lobbyCode;

  Future<void> suggestSong(String suggestion) async {
    final currentUser = await FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('lobbies')
        .doc(lobbyCode)
        .collection('suggestions')
        .add({
      'username': currentUser.email,
      'suggestion': suggestion,
      'createdAt': Timestamp.now(),
      'likesCounter': {},
    });
    _suggestionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final lobbyId = Provider.of<Users>(context).getLobbyId;
    lobbyCode = lobbyId;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                // initialData: Text('No suggestions yet'),
                stream: FirebaseFirestore.instance
                    .collection('lobbies')
                    .doc(isAdmin ? SharedPrefs().userId : lobbyId)
                    .collection('suggestions')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, suggestionsSnapshot) {
                  if (!suggestionsSnapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  final suggestions = suggestionsSnapshot.data.docs;
                  return ListView.builder(
                    itemBuilder: (context, i) {
                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white,
                              width: 0.2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: ListTile(
                            key: ValueKey(suggestions[i].data()['suggestion'] +
                                suggestions[i].data()['username']),
                            title: Text(
                              suggestions[i].data()['suggestion'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lexend',
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 0.5, top: 5),
                              child: Text(
                                'Suggested by: ' +
                                    suggestions[i].data()['username'],
                                style: TextStyle(
                                  color: Colors.pink.shade300,
                                  fontSize: 15,
                                  fontFamily: 'Lexend',
                                ),
                              ),
                            ),
                            trailing: LikeCounter(
                              i,
                              lobbyCode,
                              suggestions[i].id,
                              isAdmin,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: suggestions.length,
                  );
                },
              ),
            ),
            if (!isAdmin)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: (Offset.zero),
                        blurRadius: 1.0,
                        spreadRadius: 3.0,
                      )
                    ],
                    gradient: LinearGradient(colors: [
                      Colors.blue.shade200,
                      Colors.pink.shade100,
                    ])),
                padding:
                    EdgeInsets.only(left: 20, bottom: 15, right: 15, top: 10),
                child: Row(
                  children: [
                    Flexible(
                      flex: 10,
                      child: TextFormField(
                        controller: _suggestionController,
                        autocorrect: false,
                        enableSuggestions: false,
                        //      keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                        decoration:
                            InputDecoration(hintText: 'Suggest a song...'),
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.send_rounded),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            suggestSong(_suggestionController.text);
                          },
                        ))
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
