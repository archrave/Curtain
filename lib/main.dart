import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/splash_screen.dart';
import './screens/chat_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp(); (this gives error)

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, appSnapshot) {
        return MaterialApp(
          title: 'Curtain',
          theme: ThemeData(
            primarySwatch: Colors.pink,
            backgroundColor: Colors.pink,
            accentColor: Colors.deepPurple,
            accentColorBrightness: Brightness.dark,
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // This stream below emits a new value whenever it changes.
          // It changes whenever we log in, log out or sign Up, or when the user has already logged in and the app is opened up.
          home: appSnapshot.connectionState != ConnectionState.done
              ? SplashScreen()
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    return userSnapshot.hasData ? ChatScreen() : AuthScreen();
                  }),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
