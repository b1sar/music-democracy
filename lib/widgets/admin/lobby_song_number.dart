import 'package:flutter/material.dart';

class LobbySongNumberRow extends StatefulWidget {
  final Function(int totalSongs) setSongsTotal;

  LobbySongNumberRow(this.setSongsTotal);
  @override
  _LobbySongNumberRowState createState() => _LobbySongNumberRowState();
}

class _LobbySongNumberRowState extends State<LobbySongNumberRow> {
  int songsTotal;
  bool is4Selected = false;
  bool is5Selected = false;
  bool is6Selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: is4Selected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade200,
                        Colors.purple.shade200,
                      ],
                    ),
                  )
                : null,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  FocusScope.of(context).unfocus();
                  is4Selected = !is4Selected;
                  if (is4Selected) {
                    is5Selected = false;
                    is6Selected = false;
                    songsTotal = 4;
                    widget.setSongsTotal(songsTotal);
                  } else {
                    songsTotal = 0;
                    widget.setSongsTotal(songsTotal);
                  }
                });
              },
              icon: Icon(
                is4Selected ? Icons.music_video : Icons.radio_button_off_sharp,
                color: is4Selected ? Colors.black : Colors.white,
              ),
              label: Text(
                '4 songs',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  color: is4Selected ? Colors.black : Colors.blue.shade200,
                  fontSize: 18,
                  fontWeight: is4Selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            decoration: is5Selected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade200,
                        Colors.purple.shade200,
                      ],
                    ),
                  )
                : null,
            child: TextButton.icon(
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  is5Selected = !is5Selected;
                  if (is5Selected) {
                    is4Selected = false;
                    is6Selected = false;
                    songsTotal = 5;
                    widget.setSongsTotal(songsTotal);
                  } else {
                    songsTotal = 0;
                    widget.setSongsTotal(songsTotal);
                  }
                });
              },
              icon: Icon(
                is5Selected ? Icons.music_video : Icons.radio_button_off_sharp,
                color: is5Selected ? Colors.black : Colors.white,
              ),
              label: Text(
                '5 songs',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  color: is5Selected ? Colors.black : Colors.blue.shade200,
                  fontSize: 18,
                  fontWeight: is5Selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            decoration: is6Selected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade200,
                        Colors.purple.shade200,
                      ],
                    ),
                  )
                : null,
            child: TextButton.icon(
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  is6Selected = !is6Selected;
                  if (is6Selected) {
                    is4Selected = false;
                    is5Selected = false;
                    songsTotal = 6;
                    widget.setSongsTotal(songsTotal);
                  } else {
                    songsTotal = 0;
                    widget.setSongsTotal(songsTotal);
                  }
                });
              },
              icon: Icon(
                is6Selected ? Icons.music_video : Icons.radio_button_off_sharp,
                color: is6Selected ? Colors.black : Colors.white,
              ),
              label: Text(
                '6 songs',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  color: is6Selected ? Colors.black : Colors.blue.shade200,
                  fontSize: 18,
                  fontWeight: is6Selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
