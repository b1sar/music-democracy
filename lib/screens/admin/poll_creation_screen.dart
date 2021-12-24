import 'package:flutter/material.dart';
import 'package:music_democracy/models/sharedPrefs.dart';
import 'package:music_democracy/providers/lobbies_provider.dart';
import 'package:music_democracy/providers/poll_provider.dart';
import 'package:music_democracy/providers/timer_provider.dart';
import 'package:music_democracy/util/utility.dart';
import 'package:provider/provider.dart';

class PollCreationScreen extends StatefulWidget {
  @override
  _PollCreationScreenState createState() => _PollCreationScreenState();
}

class _PollCreationScreenState extends State<PollCreationScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double pollSize =
        Provider.of<Polls>(context).getCurrentPollSize.roundToDouble();
    return Container(
      margin: EdgeInsets.only(
        top: 80,
        left: 12,
        right: 12,
        bottom: 5,
      ),
      height: pollSize == 0 ? 200 : pollSize * 71 + 100,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            child: Text(
              'Songs for the next poll:',
              style: TextStyle(
                color: Colors.grey.shade200,
                fontSize: 23,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.blue.shade50,
                  Colors.pink.shade100,
                ]),
                //     color: Colors.pink,
                borderRadius: BorderRadius.circular(18),
              ),
              /*     margin: EdgeInsets.symmetric(
                  vertical: 100,
                  horizontal: 20,
                ), */
              padding: EdgeInsets.only(
                top: 2,
              ),
              width: double.infinity,
              //   color: Colors.grey,
              child: pollSize == 0
                  ? Center(
                      child: Text(
                        '- Start adding songs to the poll -',
                        style: TextStyle(
                          fontFamily: 'PTSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    )
                  : Consumer<Polls>(
                      builder: (ctx, pollData, child) {
                        return ListView.builder(
                            itemCount: pollData.getCurrentPollSongs.length,
                            itemBuilder: (ctx, i) {
                              return Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  border: i ==
                                          (pollData.getCurrentPollSongs.length -
                                              1)
                                      ? null
                                      : Border(
                                          bottom: BorderSide(
                                            color: Colors.black,
                                            width: 0.5,
                                          ),
                                        ),
                                ),
                                child: Center(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Icon(
                                        Icons.music_note_rounded,
                                        color: Colors.pink
                                            .shade100, //Colors.pink.shade400,
                                      ),
                                      backgroundColor: Colors.blueGrey.shade700,
                                    ),
                                    title: Text(
                                      pollData.getCurrentPollSongs[i].artist +
                                          ' - ' +
                                          pollData.getCurrentPollSongs[i].name,
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        Provider.of<Polls>(
                                          context,
                                          listen: false,
                                        ).removeFromPoll(
                                            pollData.getCurrentPollSongs[i]);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            width: 160,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final int songsPerPoll =
                    Provider.of<Lobbies>(context, listen: false)
                        .getLobbySongsPerPoll;
                if (Provider.of<Polls>(context, listen: false)
                        .getCurrentPollSize !=
                    songsPerPoll) {
                  showSnackBarError(context, 'Your lobby requires $songsPerPoll songs per poll!');
                  return;
                }
                try {
                  setState(() {
                    isLoading = true;
                  });
                  Provider.of<Polls>(context, listen: false)
                      .createPoll()
                      .whenComplete(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Poll Created!',
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 1),
                      ),
                    );
                    setState(() {
                      isLoading = false;
                    });
                    SharedPrefs().setLobbyDuration(
                        Provider.of<Lobbies>(context, listen: false)
                            .getLobbyDuration);
                    Provider.of<LobbyTimer>(context, listen: false)
                        .streamTimer();
                  });
                } catch (error) {
                  print(error.message);
                  throw error;
                }
              },
              child: isLoading
                  ? CircularProgressIndicator(
                      strokeWidth: 5,
                    )
                  : Text(
                      'CREATE POLL',
                      style: TextStyle(fontSize: 16),
                    ),
              style: ElevatedButton.styleFrom(
                primary: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
