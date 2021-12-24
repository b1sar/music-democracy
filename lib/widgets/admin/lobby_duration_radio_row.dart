import 'package:flutter/material.dart';

class LobbyDurationRadioButtonRow extends StatefulWidget {
  final Function(int duration) setLobbyDuration;

  LobbyDurationRadioButtonRow(this.setLobbyDuration);

  @override
  _LobbyDurationRadioButtonRow createState() => _LobbyDurationRadioButtonRow();
}

class _LobbyDurationRadioButtonRow extends State<LobbyDurationRadioButtonRow> {
  int duration;
  bool is60Selected = false;
  bool is90Selected = false;
  bool is120Selected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: is60Selected
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
                is60Selected = !is60Selected;
                if (is60Selected) {
                  is90Selected = false;
                  is120Selected = false;
                  duration = 60;
                  widget.setLobbyDuration(duration);
                } else {
                  duration = 0;
                  widget.setLobbyDuration(duration);
                }
              });
            },
            icon: Icon(
              is60Selected ? Icons.timer_sharp : Icons.radio_button_off_sharp,
              color: is60Selected ? Colors.black : Colors.white,
            ),
            label: Text(
              '60 sec',
              style: TextStyle(
                fontFamily: 'Lexend',
                color: is60Selected ? Colors.black : Colors.blue.shade200,
                fontSize: 18,
                fontWeight: is60Selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
        Container(
          decoration: is90Selected
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
                is90Selected = !is90Selected;
                if (is90Selected) {
                  is60Selected = false;
                  is120Selected = false;
                  duration = 90;
                  widget.setLobbyDuration(duration);
                } else {
                  duration = 0;
                  widget.setLobbyDuration(duration);
                }
              });
            },
            icon: Icon(
              is90Selected ? Icons.timer_sharp : Icons.radio_button_off_sharp,
              color: is90Selected ? Colors.black : Colors.white,
            ),
            label: Text(
              '90 sec',
              style: TextStyle(
                fontFamily: 'Lexend',
                color: is90Selected ? Colors.black : Colors.blue.shade200,
                fontSize: 18,
                fontWeight: is90Selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
        Container(
          decoration: is120Selected
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
                is120Selected = !is120Selected;
                if (is120Selected) {
                  is60Selected = false;
                  is90Selected = false;
                  duration = 120;
                  widget.setLobbyDuration(duration);
                } else {
                  duration = 0;
                  widget.setLobbyDuration(duration);
                }
              });
            },
            icon: Icon(
              is120Selected ? Icons.timer_sharp : Icons.radio_button_off_sharp,
              color: is120Selected ? Colors.black : Colors.white,
            ),
            label: Text(
              '120 sec',
              style: TextStyle(
                fontFamily: 'Lexend',
                color: is120Selected ? Colors.black : Colors.blue.shade200,
                fontSize: 18,
                fontWeight: is120Selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
