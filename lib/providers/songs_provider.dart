import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_democracy/models/sharedPrefs.dart';

import '../models/song.dart';

class Songs with ChangeNotifier {
  static List<Song> _songs = [];

  List<Song> get songs {
    _songs.sort((a, b) => a.artist.compareTo(b.artist));
    return [..._songs];
  }

  List<Song> getSongsByGenre(String genre) {
    List<Song> songsByGenre =
        _songs.where((song) => song.genres.contains(genre)).toList();
    songsByGenre.sort((a, b) => a.artist.compareTo(b.artist));
    return songsByGenre;
  }

  List<Song> getSongsBySearch(String searchInput) {
    List<Song> songsBySearch = _songs
        .where((song) =>
            (song.artist.toLowerCase().contains(searchInput.toLowerCase()) ||
                song.name.toLowerCase().contains(searchInput.toLowerCase())))
        .toList();
    if (songsBySearch.isEmpty) return [];
    songsBySearch.sort((a, b) => a.artist.compareTo(b.artist));
    return songsBySearch;
  }

  Future<void> initSongs() async {
    try {
      final songs =
          await FirebaseFirestore.instance.collection('songsStarterPack').get();
      final List<Song> songsToReturn = [];
      final userId = SharedPrefs().userId;
      songs.docs.forEach((document) async {
        await FirebaseFirestore.instance
            .collection('adminSongs')
            .doc(userId)
            .collection('songsList')
            .doc(document['songArtist'] + ' - ' + document['songName'])
            .set({
          'songName': document['songName'],
          'songArtist': document['songArtist'],
          'songGenres': document['songGenres'],
        });
        songsToReturn.add(Song(
          document['songName'],
          document['songArtist'],
          (document['songGenres'] as List)
              ?.map((item) => item as String)
              ?.toList(),
        ));
        //    print(songsToReturn[0].genres.runtimeType);
      });
      _songs = songsToReturn;
      SharedPrefs().initalizeSongs();
      notifyListeners();
    } catch (error) {
      print('An error ocurred while initialising');
      throw error;
    }
  }

  Future<void> fetchAndSetSongs() async {
    final userId = SharedPrefs().userId;
    final songs = await FirebaseFirestore.instance
        .collection('adminSongs')
        .doc(userId)
        .collection('songsList')
        .get();
    final List<Song> songsToReturn = [];
    songs.docs.forEach((doc) {
      songsToReturn.add(Song(
        doc['songName'],
        doc['songArtist'],
        (doc['songGenres'] as List)?.map((item) => item as String)?.toList(),
      ));
    });
    _songs = songsToReturn;
    notifyListeners();
    //   return songsToReturn;
  }

  Future<void> addSong(Song song) async {
    try {
      await FirebaseFirestore.instance
          .collection('adminSongs')
          .doc(SharedPrefs().userId)
          .collection('songsList')
          .doc(song.artist + ' - ' + song.name)
          .set({
        'songName': song.name,
        'songArtist': song.artist,
        'songGenres': song.genres,
      });
    } catch (error) {
      print('error while adding');
      throw error;
    }
    _songs.add(song);
    notifyListeners();
  }

  Future<void> deleteSong(String songName, String songArtist) async {
    try {
      await FirebaseFirestore.instance
          .collection('adminSongs')
          .doc(SharedPrefs().userId)
          .collection('songsList')
          .doc(songArtist + ' - ' + songName)
          .delete();
      print('succes');
    } catch (error) {
      print(error.message);
      throw error;
    }
    _songs.removeWhere((element) =>
        (element.name == songName && element.artist == songArtist));
    notifyListeners();
  }
}
