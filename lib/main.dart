import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_democracy/providers/lobbies_provider.dart';
import 'package:music_democracy/providers/timer_provider.dart';
import 'package:music_democracy/screens/admin/admin_poll_winners_screen.dart';
import 'package:music_democracy/screens/admin/create_lobby_screen.dart';
import 'package:music_democracy/screens/admin/admin_suggestions_screen.dart';
import 'package:music_democracy/screens/user/user_start_screen.dart';
import 'package:music_democracy/services/authentication_service.dart';
import 'package:provider/provider.dart';
import './screens/admin/add_song_screen.dart';
import './models/sharedPrefs.dart';
import './screens/admin_screen.dart';

import './screens/user_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import 'providers/poll_provider.dart';
import 'providers/songs_provider.dart';
import 'providers/users_provider.dart';

final sharedPrefs = SharedPrefs();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await sharedPrefs.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        initialData: [],
        builder: (context, appSnapshot) {
          print(appSnapshot);
          if(appSnapshot.hasData) {
            return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (ctx) => Songs(),
              ),
              ChangeNotifierProvider(
                create: (ctx) => Lobbies(),
              ),
              ChangeNotifierProvider(
                create: (ctx) => LobbyTimer(),
              ),
              ChangeNotifierProvider(
                create: (ctx) => Polls(),
              ),
              ChangeNotifierProvider(
                create: (ctx) => Users(),
              ),
              Provider<AuthenticationService>(
                create: (_) => AuthenticationService(),
              ),
              StreamProvider(
                create: (context) => context.read<AuthenticationService>().authStateChanges
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Music Democracy',
              theme: ThemeData(
                fontFamily: 'Raleway',
                primarySwatch: Colors.deepPurple,
                canvasColor: Color.fromRGBO(10, 5, 27, 0.9),
              ),
              home:  appSnapshot.connectionState != ConnectionState.done
                  ? Text("Bug1")
                  : StreamBuilder<User>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (ctx, userSnapshot) {
                        print(userSnapshot);
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Bug2");
                        }
                        
                        if (userSnapshot.hasData) {
                          User user = userSnapshot.data;
                          print(user);
                          return FutureBuilder(
                            future: buildFuture(user),
                            builder: ( context, snap) {
                              if (snap.hasData) {
                                if(snap.data) {
                                  return AdminScreen();
                                }
                                  return UserStartScreen();
                              } else if (snap.hasError) {
                                print(snap.error);
                                return Text("Bug4");
                              }
                              print(snap.data);
                              return Text("Bug3");
                            }
                            );
                        }
                        return AuthScreen();
                      }),
              routes: {
                SplashScreen.routeName: (ctx) => SplashScreen(),
                AddSongScreen.routeName: (ctx) => AddSongScreen(),
                CreateLobbyScreen.routeName: (ctx) => CreateLobbyScreen(),
                UserScreen.routeName: (ctx) => UserScreen(),
                AuthScreen.routeName: (ctx) => AuthScreen(),
                AdminSuggestionsScreen.routeName: (ctx) => AdminSuggestionsScreen(),
                AdminPollWinnersScreen.routeName: (ctx) => AdminPollWinnersScreen(),
              },
            ),
          );
          }
          else {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Text("Hata var ")
              );
          }
        });
  }

  buildFuture(User user) async {
    var tempUser = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.email).get();
    return tempUser.get('isAdmin');
  }
}
