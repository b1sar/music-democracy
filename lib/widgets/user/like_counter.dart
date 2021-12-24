import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_democracy/models/sharedPrefs.dart';

class LikeCounter extends StatefulWidget {
  final index;
  final lobbyCode;
  final docId;
  final isAdmin;
  LikeCounter(this.index, this.lobbyCode, this.docId, this.isAdmin);
  @override
  _LikeCounterState createState() => _LikeCounterState();
}

class _LikeCounterState extends State<LikeCounter> {
  bool _liked = false;
  bool _isLoading;
  final String userId = SharedPrefs().userId;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    final suggestion = await FirebaseFirestore.instance
        .collection('lobbies')
        .doc(widget.isAdmin ? SharedPrefs().userId : widget.lobbyCode)
        .collection('suggestions')
        .doc(widget.docId)
        .get();
    if (suggestion.data()['likesCounter'].containsKey(userId)) {
      setState(() {
        _liked = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //    height: 200,
      child:
          /* _isLoading
          ? /*CircularProgressIndicator(
              strokeWidth: 0.5,
            )*/
          Text(
              'Loading...',
              style: TextStyle(color: Colors.white, fontSize: 10),
            )
          :*/
          Column(
        children: [
          Flexible(
            flex: 4,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              splashColor: Colors.blue,
              onTap: () async {
                if (!_liked) {
                  setState(() {
                    _liked = !_liked;
                  });
                  try {
                    await FirebaseFirestore.instance
                        .collection('lobbies')
                        .doc(widget.isAdmin
                            ? SharedPrefs().userId
                            : widget.lobbyCode)
                        .collection('suggestions')
                        .doc(widget.docId)
                        .update({
                      'likesCounter.$userId': '$userId',
                    });
                  } catch (error) {
                    setState(() {
                      _liked = !_liked;
                    });
                  }
                } else {
                  setState(() {
                    _liked = !_liked;
                  });
                  try {
                    await FirebaseFirestore.instance
                        .collection('lobbies')
                        .doc(widget.isAdmin
                            ? SharedPrefs().userId
                            : widget.lobbyCode)
                        .collection('suggestions')
                        .doc(widget.docId)
                        .update({
                      'likesCounter.$userId': FieldValue.delete(),
                    });
                  } catch (error) {
                    setState(() {
                      _liked = !_liked;
                    });
                  }
                }
              },
              child: Container(
                height: 80,
                width: 48,
                decoration: BoxDecoration(
                    color: Colors.pink.shade600,
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(
                  Icons.thumb_up_sharp,
                  color: _liked
                      ? Colors.deepPurple.shade700
                      : Colors.grey.shade200,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: StreamBuilder(
              //    initialData: Text('0'),
              stream: FirebaseFirestore.instance
                  .collection('lobbies')
                  .doc(widget.isAdmin ? SharedPrefs().userId : widget.lobbyCode)
                  .collection('suggestions')
                  .doc(widget.docId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<dynamic> likesSnapshots) {
                try {
                  final likesCounter = likesSnapshots.data;
                  //  print(likesCounter['likesCounter'].length.toString());
                  return Text(
                    likesCounter['likesCounter'].length.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'Lexend',
                    ),
                  );
                } catch (error) {
                  //  print(error.message);
                  return Text('0');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
