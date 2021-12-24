import 'package:flutter/material.dart';
import 'package:music_democracy/models/sharedPrefs.dart';
import 'package:music_democracy/providers/users_provider.dart';
import 'package:music_democracy/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class UserStartScreen extends StatefulWidget {
  @override
  _UserStartScreenState createState() => _UserStartScreenState();
}

class _UserStartScreenState extends State<UserStartScreen> {
  final _codeController = TextEditingController();
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(10, 5, 27, 0.8),
              Color.fromRGBO(33, 98, 131, 0.8),
              //    Colors.pink.shade300,
            ],
          ),
        ),
        child: Scaffold(
            drawer: AppDrawer('User', context),
            backgroundColor: Colors.blue,
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                  'Join a Lobby',
                )
                  ],
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.blue.shade200,
                              Colors.pink.shade100,
                            ],
                          ),
                        ),
                        height: 60,
                        width: 250,
                        child: Container(
                          child: Center(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _codeController,
                              style: TextStyle(
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                              ),
                              decoration: InputDecoration(
                                labelStyle: TextStyle(fontFamily: 'PTSans'),
                                hintText: 'Type the lobby code...',
                                hintStyle: TextStyle(
                                  fontFamily: 'Lexend',
                                  //         fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_codeController.text.isEmpty) return;
                            setState(() {
                              _isLoading = true;
                            });
                            print(_isLoading);
                            try {
                              Provider.of<Users>(context, listen: false)
                                  .addUserToLobby(_codeController.text,
                                      SharedPrefs().userId, context);
                            } catch (error) {
                              print(error.message);
                              throw error;
                            }
                            setState(() {
                              _isLoading = false;
                            });
                            _codeController.clear();
                          },
                          icon: Icon(Icons.people_alt),
                          label:
                              _isLoading ? Text('Wait') : Text('Join')),
                      if (_isLoading) Text('Loading...')
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
