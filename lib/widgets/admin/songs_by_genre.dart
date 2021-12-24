import 'package:flutter/material.dart';
import 'package:music_democracy/widgets/admin/songs_future_builder.dart';
import 'package:provider/provider.dart';
import 'package:music_democracy/models/sharedPrefs.dart';
import 'package:music_democracy/providers/songs_provider.dart';

class SongsByGenre extends StatelessWidget {
  final String genre;
  final Function goBack;
  SongsByGenre(this.genre, this.goBack);
  @override
  Widget build(BuildContext context) {
    return !SharedPrefs().didSongsInit
        ? FutureBuilder(
            future: Provider.of<Songs>(context, listen: false).initSongs(),
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator.adaptive());
              } else
                return Center(
                  child: Text(
                    'Songs Starter Pack was initialized.\nPlease restart the app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
            })
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.black38),
                padding: EdgeInsets.only(left: 10),
                width: double.infinity,
                child: Row(
                  //      mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded),
                      onPressed: goBack,
                      color: Colors.pink,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        'Your ' + genre + ' Songs Collection:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.pink.shade700,
                          fontFamily: 'Lexend',
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: SongsFutureBuilder(genre)),
            ],
          );
  }
}
