import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_democracy/models/lobby.dart';
import 'package:music_democracy/models/sharedPrefs.dart';

class Lobbies with ChangeNotifier {
  static Lobby _lobby = Lobby(
    name: 'Non-existent',
    capacity: 0,
    duration: 0,
    songsPerPoll: 0,
    lobbyCode: '',
  );

  Future<void> createLobby(Lobby lobby) async {
    try {
      await FirebaseFirestore.instance
          .collection('lobbies')
          .doc(SharedPrefs().userId)
          .set({
        'lobbyName': lobby.name,
        'lobbyCapacity': lobby.capacity,
        'lobbyDuration': lobby.duration,
        'lobbySongsPerPoll': lobby.songsPerPoll,
        'lobbyCode': lobby.lobbyCode,
        'lobbyOwnerId': lobby.ownerId,
        'poll': {},
        'users': {},
        'pollVotes': {},
        'pollVotesCounter': {},
        'lobbyTimer': lobby.duration,
      });
    } catch (error) {
      print(error.message);
      throw error;
    }
    SharedPrefs().setLobbyDuration(lobby.duration);
    _lobby = lobby;
    notifyListeners();
  }

  Future<void> fetchAndSetPreviousLobby() async {
    try {
      final previousLobby = await FirebaseFirestore.instance
          .collection('lobbies')
          .doc(SharedPrefs().userId)
          .get();
      final tmpLobby = Lobby(
        name: previousLobby.data()['lobbyName'],
        capacity: previousLobby.data()['lobbyCapacity'],
        duration: previousLobby.data()['lobbyDuration'],
        songsPerPoll: previousLobby.data()['lobbySongsPerPoll'],
        lobbyCode: previousLobby.data()['lobbyCode'],
      );
      _lobby = tmpLobby;
      notifyListeners();
    } catch (error) {
      print(error.message);
      throw error;
    }
  }

  @deprecated
  Future<void> fetchAndSetUserLobby() async {
    final adminId = await FirebaseFirestore.instance
        .collection('lobbyCodes')
        .doc(_lobby.lobbyCode)
        .get();
    // print(adminId['lobbyCodeAsAdminId']);
    try {
      final lobbyFrom = await FirebaseFirestore.instance
          .collection('lobbies')
          .doc(adminId['lobbyCodeAsAdminId'])
          .get();
      final tmpLobby = Lobby(
        name: lobbyFrom.data()['lobbyName'],
        capacity: lobbyFrom.data()['lobbyCapacity'],
        duration: lobbyFrom.data()['lobbyDuration'],
        songsPerPoll: lobbyFrom.data()['lobbySongsPerPoll'],
        lobbyCode: lobbyFrom.data()['lobbyCode'],
      );
      SharedPrefs().setLobbyDuration(lobbyFrom.data()['lobbyTimer']);
      _lobby = tmpLobby;
      notifyListeners();
    } catch (error) {
      print(error.message);
      throw error;
    }
  }

  Future<Lobby> get getCurrentLobby async {
    var currentUserId = SharedPrefs().userId;
    var lobby = await FirebaseFirestore.instance.collection("lobbies").doc(currentUserId).get();
    Lobby currentLobby = Lobby(
      name: lobby["lobbyName"],
      capacity: lobby["lobbyCapacity"],
      duration: lobby["lobbyDuration"],
      songsPerPoll: lobby["lobbySongsPerPoll"],
      lobbyCode: lobby["lobbyCode"],
      ownerId: lobby["lobbyOwnerId"]
    );
    _lobby = currentLobby;
    return currentLobby;
  }

  int get getLobbyDuration {
    return _lobby.duration;
  }

  int get getLobbySongsPerPoll {
    return _lobby.songsPerPoll;
  }

  String get getLobbyCode {
    return _lobby.lobbyCode;
  }

  void setLobbyCode(String code) {
    _lobby.lobbyCode = code;
  }

  void setLobbyDuration(int duration) {
    _lobby.duration = duration;
  }
}
