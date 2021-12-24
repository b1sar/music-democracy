import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_democracy/models/sharedPrefs.dart';
import 'package:music_democracy/providers/users_provider.dart';
import 'package:provider/provider.dart';

class PollWinnersScreen extends StatelessWidget {
  final bool isAdmin;
  PollWinnersScreen(this.isAdmin);
  @override
  Widget build(BuildContext context) {
    final lobbyId = Provider.of<Users>(context).getLobbyId;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('lobbies')
            .doc(isAdmin ? SharedPrefs().userId : lobbyId)
            .collection('winners')
            .orderBy('timeWon', descending: true)
            .snapshots(),
        builder: (context, pollWinnersSnapshot) {
          if (pollWinnersSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final winners = pollWinnersSnapshot.data.docs;
          return ListView.builder(
              itemCount: winners.length,
              itemBuilder: (context, i) {
                return Container(
                  height: 100,
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 10,
                    ),
                    elevation: 10,
                    color: Colors.black45,
                    child: Center(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(Icons.music_note),
                        ),
                        title: Text(
                          winners[i]['winner'],
                          style: TextStyle(
                            color: Colors.blue.shade100,
                            fontSize: 18,
                            fontFamily: 'Lexend',
                          ),
                        ),
                        subtitle: Text(
                          'Won at: ' +
                              DateTime.parse(winners[i]['timeWon'])
                                  .toIso8601String()
                                  .substring(11, 16) +
                              'h',
                          style: TextStyle(
                            color: Colors.white38,
                            fontFamily: 'Lexend',
                          ),
                        ),
                        trailing: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/trophy.png'),
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
