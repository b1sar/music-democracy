import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_democracy/models/sharedPrefs.dart';

import 'package:music_democracy/models/song.dart';
import 'package:music_democracy/providers/lobbies_provider.dart';

class Polls with ChangeNotifier {
  List<Song> _currentPoll = [];

  void addToPoll(Song song) {
    _currentPoll.add(song);
    notifyListeners();
  }

  void removeFromPoll(Song song) {
    _currentPoll.removeWhere((element) => element == song);
    notifyListeners();
  }

  List<Song> get getCurrentPollSongs {
    return [..._currentPoll];
  }

  int get getCurrentPollSize {
    return _currentPoll.length;
  }

  Future<void> registerVote(
      int songIndex, String lobbyId, String userId) async {
    /* bool didVote = false;
    await FirebaseFirestore.instance
        .collection('lobbies')
        .doc(lobbyId)
        .get()
        .then((doc) {
      doc.data()['pollVotesCounter'].forEach((key, value) {
        if (key == userId) {
          print('yes');
          didVote = true;
          return;
        }
      });
    });
    if (didVote) return; */
    await FirebaseFirestore.instance
        .collection('lobbies')
        .doc(lobbyId)
        .update({'pollVotes.song$songIndex.$userId': '$userId'});
    await FirebaseFirestore.instance
        .collection('lobbies')
        .doc(lobbyId)
        .update({'pollVotesCounter.$userId': '$songIndex'});
  }

  Future<void> createPoll() async {
    if (getCurrentPollSize == 4)
      await FirebaseFirestore.instance
          .collection('lobbies')
          .doc(SharedPrefs().userId)
          .update(
        {
          'poll': {
            'song0': _currentPoll[0].artist + ' - ' + _currentPoll[0].name,
            'song1': _currentPoll[1].artist + ' - ' + _currentPoll[1].name,
            'song2': _currentPoll[2].artist + ' - ' + _currentPoll[2].name,
            'song3': _currentPoll[3].artist + ' - ' + _currentPoll[3].name,
          },
          'pollVotesCounter': {},
          'pollVotes': {},
        },
      );
    else if (getCurrentPollSize == 5)
      await FirebaseFirestore.instance
          .collection('lobbies')
          .doc(SharedPrefs().userId)
          .update(
        {
          'poll': {
            'song0': _currentPoll[0].artist + ' - ' + _currentPoll[0].name,
            'song1': _currentPoll[1].artist + ' - ' + _currentPoll[1].name,
            'song2': _currentPoll[2].artist + ' - ' + _currentPoll[2].name,
            'song3': _currentPoll[3].artist + ' - ' + _currentPoll[3].name,
            'song4': _currentPoll[4].artist + ' - ' + _currentPoll[4].name,
          },
          'pollVotesCounter': {},
          'pollVotes': {},
        },
      );
    else if (getCurrentPollSize == 6)
      await FirebaseFirestore.instance
          .collection('lobbies')
          .doc(SharedPrefs().userId)
          .update(
        {
          'poll': {
            'song0': _currentPoll[0].artist + ' - ' + _currentPoll[0].name,
            'song1': _currentPoll[1].artist + ' - ' + _currentPoll[1].name,
            'song2': _currentPoll[2].artist + ' - ' + _currentPoll[2].name,
            'song3': _currentPoll[3].artist + ' - ' + _currentPoll[3].name,
            'song4': _currentPoll[4].artist + ' - ' + _currentPoll[4].name,
            'song5': _currentPoll[5].artist + ' - ' + _currentPoll[5].name,
          },
          'pollVotesCounter': {},
          'pollVotes': {},
        },
      );
  }
}
