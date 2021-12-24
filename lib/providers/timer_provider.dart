import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_democracy/models/sharedPrefs.dart';

import 'lobbies_provider.dart';

class LobbyTimer with ChangeNotifier {
  int timeRemaining = Lobbies().getLobbyDuration;

  void timer() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) {
      timeRemaining--;
      notifyListeners();
      if (timeRemaining == 0 || timeRemaining < 0) t.cancel();
    });
  }

  void streamTimer() {
    const oneSec = const Duration(seconds: 1);
    final String userId = SharedPrefs().userId;
    new Timer.periodic(oneSec, (Timer t) async {
      int newTime = SharedPrefs().lobbyDuration;
      SharedPrefs().setLobbyDuration(newTime - 1);
      FirebaseFirestore.instance.collection('lobbies').doc(userId).update({
        'lobbyTimer': SharedPrefs().lobbyDuration,
      });
      //   notifyListeners();
      if (newTime - 1 == 0 || newTime < 0) {
        t.cancel();
        FirebaseFirestore.instance.collection('lobbies').doc(userId).update({
          'lobbyTimer': 0,
        });
        calculateWinner();
      }
    });
  }

  Future<void> calculateWinner() async {
    final lobbyData = await FirebaseFirestore.instance
        .collection('lobbies')
        .doc(SharedPrefs().userId)
        .get();
    int lobbySongsPerPoll = lobbyData['lobbySongsPerPoll'];
    int winnerIndex = 0;
    List<int> songVotes = [];
    for (int i = 0; i < lobbySongsPerPoll; i++) songVotes.add(0);
    for (int i = 0; i < lobbySongsPerPoll; i++) {
      try {
        print(lobbyData.data()['pollVotes']['song$i'].length);
        songVotes[i] = lobbyData.data()['pollVotes']['song$i'].length;
        print(lobbyData.data()['poll']['song$i']);
      } catch (error) {
        print('error no vote found');
        songVotes[i] = 0;
      }
      if (i == 0)
        continue;
      else {
        if (songVotes[i] >= songVotes[winnerIndex]) winnerIndex = i;
      }
    }
    print(winnerIndex);
    print(lobbyData.data()['poll']['song$winnerIndex']);
    await FirebaseFirestore.instance
        .collection('lobbies')
        .doc(SharedPrefs().userId)
        .collection('winners')
        .add({
      'winner': lobbyData.data()['poll']['song$winnerIndex'],
      'timeWon': DateTime.now().toIso8601String(),
    });
    //   lobbyData.data()[]
  }

  int get timeLeft {
    return timeRemaining;
  }

  void setTimeLeft(int time) {
    this.timeRemaining = time;
  }
}
