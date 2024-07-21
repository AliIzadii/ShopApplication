import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop/firebase_options.dart';
import 'package:shop/routes/home.dart';
import 'package:shop/routes/login.dart';

class handle extends StatelessWidget {
  final Future<FirebaseApp> firebase_test =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase_test,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Firebase Is Not Connected'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                Scaffold(
                  body: Center(
                    child: Text('${snapshot.error}'),
                  ),  
                );
              }
              if (snapshot.connectionState == ConnectionState.active) {
                User? username = snapshot.data;
                if (username == null) {
                  return loginPage();
                } else {
                  return homePage();
                }
              }
              return CircularProgressIndicator();
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
