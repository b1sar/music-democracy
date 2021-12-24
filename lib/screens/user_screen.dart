import 'package:flutter/material.dart';
import 'package:my_dj_app/providers/lobbies_provider.dart';
import 'package:my_dj_app/providers/timer_provider.dart';
import 'package:my_dj_app/screens/user/poll_winners_screen.dart';
import 'package:my_dj_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'user/lobby_screen.dart';
import 'user/suggestions_screen.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user-screen';
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Lobbies>(context, listen: false).fetchAndSetUserLobby();
    print(Provider.of<Lobbies>(context, listen: false).getLobbyDuration);
    Provider.of<LobbyTimer>(context, listen: false).setTimeLeft(
        Provider.of<Lobbies>(context, listen: false).getLobbyDuration);
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  final List<Widget> _pages = [
    LobbyScreen(),
    SuggestionsScreen(false),
    PollWinnersScreen(false),
  ];

  final List<String> _titles = [
    'Lobby Status',
    'Next Songs Suggestions',
    'Poll Winners'
  ];

  bool _isLoading = false;

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

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
          ],
        ),
      ),
      child: Scaffold(
        drawer: AppDrawer('LobbyEntered', context),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            _titles[_selectedPageIndex],
            style: TextStyle(fontFamily: 'Raleway'),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : _pages[_selectedPageIndex],
        bottomNavigationBar: BottomNavigationBar(
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
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.library_music),
              ),
              label: 'LOBBY',
            ),
            BottomNavigationBarItem(
                icon: Container(
                  child: Icon(Icons.chat_rounded),
                  margin: EdgeInsets.only(bottom: 2),
                ),
                label: 'SUGGESTIONS'),
            BottomNavigationBarItem(
                icon: Container(
                  child: Icon(Icons.music_note_rounded),
                  margin: EdgeInsets.only(bottom: 2),
                ),
                label: 'WINNERS'),
          ],
        ),
      ),
    );
  }
}
