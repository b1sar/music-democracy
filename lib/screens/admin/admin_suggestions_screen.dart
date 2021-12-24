import 'package:flutter/material.dart';
import 'package:music_democracy/screens/user/suggestions_screen.dart';

class AdminSuggestionsScreen extends StatelessWidget {
  static final routeName = '/admin-suggestions';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromRGBO(10, 5, 27, 0.9),
            Color.fromRGBO(33, 98, 131, 0.9),
            //    Colors.pink.shade300,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text(
            'Next Song Suggestions',
            style: TextStyle(fontFamily: 'Raleway'),
          ),
          // backgroundColor: Colors.transparent,
        ),
        body: SuggestionsScreen(true),
      ),
    );
  }
}
