import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VotePercentageStream extends StatelessWidget {
  final String lobbyId;
  final int index;
  final bool isAdmin;
  VotePercentageStream(this.lobbyId, this.index, this.isAdmin);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('lobbies')
          .doc(lobbyId)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> pollVoting) {
        /*   if (isAdmin) {
          if (pollVoting.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
        }*/
        var pollData = pollVoting.data;
        int songTotalVotes = 0;
        int pollTotalVotes = 0;
        try {
          pollTotalVotes = pollData['pollVotesCounter'].length;
        } catch (error) {
          pollTotalVotes = 0;
        }
        try {
          songTotalVotes = pollData['pollVotes']['song$index'].length;
        } catch (error) {
          songTotalVotes = 0;
        }
        /*  if (pollVoting.connectionState == ConnectionState.waiting)
          return Text('0%'); */
        if (songTotalVotes == null) songTotalVotes = 0;
        if (pollTotalVotes == null) pollTotalVotes = 0;
        if (isAdmin) {
          if (songTotalVotes == 0) return Text('0%');
          if (pollTotalVotes == 0) return Text('0%');
        } else {
          if (songTotalVotes == 0) return Text('0%');
          if (pollTotalVotes == 0) return Text('Refresh');
        }
        double songPercentage = songTotalVotes / pollTotalVotes * 100;
        return Text(
          songPercentage.toStringAsFixed(0) + '%',
          style: TextStyle(
              //color:
              ),
        );
      },
    );
  }
}
