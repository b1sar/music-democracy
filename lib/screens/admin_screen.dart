import 'package:flutter/material.dart';
import 'package:music_democracy/models/sharedPrefs.dart';
import 'package:music_democracy/providers/songs_provider.dart';
import 'package:music_democracy/screens/admin/add_song_screen.dart';
import 'package:music_democracy/screens/admin/poll_creation_screen.dart';
import 'package:music_democracy/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../screens/admin/songs_screen.dart';
import 'admin/lobby_status_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final List<Widget> _pages = [
    //  DashboardScreen(),
    LobbyStatusScreen(),
    //SuggestionsScreen(true),
    PollCreationScreen(),
    SongsScreen(),
  ];

  final List<String> _titles = [
    //  'Dashboard',
    'Lobby Status',
    // 'Next Song Suggestions',
    'Poll Creation',
    'Songs Library',
  ];

  int _selectedPageIndex = 0;
  bool changeCanvas = false;
  bool isLoading = false;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    //   if (SharedPrefs().didSongsInit)
    //     Provider.of<Songs>(context, listen: false).fetchAndSetSongs();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      isLoading = true;
    });
    if (SharedPrefs().didSongsInit)
      Provider.of<Songs>(context, listen: false)
          .fetchAndSetSongs()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    else
      setState(() {
        isLoading = false;
      });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue[100],
            Colors.blue[200],
            //    Colors.pink.shade300,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: AppDrawer('Admin', context),
        appBar: AppBar(
          actions: [
            if (_selectedPageIndex == 2)
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddSongScreen.routeName);
                  },
                  /*        label: Text(
                    'Add Song',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontFamily: 'Lexend',
                    ),
                  ), */
                  icon: Icon(
                    Icons.add,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
          ],
          title: Text(
            _titles[_selectedPageIndex],
            style: TextStyle(fontFamily: 'Raleway'),
          ),
          backgroundColor: Colors.transparent,
        ), //Colors.transparent.withOpacity(0.8)),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _pages[_selectedPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          onTap: _selectPage,
          backgroundColor: Color.fromRGBO(10, 5, 27, 0.9),
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.pink,
          currentIndex: _selectedPageIndex,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 11,
          ),
          items: [
            /*   BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.dashboard),
              ),
              label: 'DASHBOARD',
            ), */
            BottomNavigationBarItem(
                icon: Container(
                  child: Icon(Icons.people),
                  margin: EdgeInsets.only(bottom: 2),
                ),
                label: 'LOBBY'),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.poll),
              ),
              label: 'POLL',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.music_note),
              ),
              label: 'SONGS',
            ),
          ],
        ),
      ),
    );
  }
}
