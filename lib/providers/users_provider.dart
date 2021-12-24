import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_democracy/providers/lobbies_provider.dart';
import 'package:music_democracy/screens/user_screen.dart';
import 'package:music_democracy/util/utility.dart';
import 'package:provider/provider.dart';

class Users with ChangeNotifier {
  String lobbyId = '';

  String get getLobbyId {
    return this.lobbyId;
  }

  Future<void> addUserToLobby(
    String enteredCode,
    String userId,
    BuildContext context,
  ) async {
    try {
      //_showMyDialog('albino', 'boim', context);
      final adminId = await FirebaseFirestore.instance
          .collection('lobbyCodes')
          .doc(enteredCode)
          .get();
      lobbyId = adminId['lobbyCodeAsAdminId'];
    } catch (error) {
      print(error.message);
      showSnackBarError(context, 'Could not find a lobby with entered code');
      throw error;
    }
    try {
      final adminId = await FirebaseFirestore.instance
          .collection('lobbyCodes')
          .doc(enteredCode)
          .get();
      
      final userName = await FirebaseAuth.instance.currentUser;
      
      await FirebaseFirestore.instance
          .collection('lobbies')
          .doc(adminId['lobbyCodeAsAdminId'])
          .update({
        'users.$userId': userName.uid,
      });
      final fetchedDuration = await FirebaseFirestore.instance
          .collection('lobbies')
          .doc(lobbyId)
          .get();
      Provider.of<Lobbies>(context, listen: false).setLobbyCode(enteredCode);
      Provider.of<Lobbies>(context, listen: false)
          .setLobbyDuration(fetchedDuration['lobbyDuration']);
      notifyListeners();
      // Navigator.of(context).pop();
      Navigator.of(context).pushNamed(UserScreen.routeName);
    } catch (error) {
      print(error.message);
      throw error;
    }
  }

  Future<void> removeUserFromLobby(String userId, String lobbyCode,
      BuildContext context, BuildContext drawer) async {
    print(userId);
    print(lobbyCode);
    Navigator.of(drawer).pop();
    final adminId = await FirebaseFirestore.instance
        .collection('lobbyCodes')
        .doc(lobbyCode)
        .get();
    await FirebaseFirestore.instance
        .collection('lobbies')
        .doc(adminId['lobbyCodeAsAdminId'])
        .update({
      'users.$userId': FieldValue.delete(),
    });
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }

  Future<void> _showMyDialog(
      String name, String artist, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey.shade100,
          title: Center(
            child: Text('Joining...',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black54,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                )),
          ),
          content: Container(
            margin: const EdgeInsets.all(5),
            child: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.deepPurple.shade800),
                strokeWidth: 3.5,
              )),
            ),
          ),
        );
      },
    );
  }
}
