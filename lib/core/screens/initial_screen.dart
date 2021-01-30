import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forestMapApp/core/adapters/firebase_auth_adapter.dart';
import 'package:get_it/get_it.dart';

class InitialScreen extends StatelessWidget {
  final _firebaseAuthAdapter = GetIt.I<FirebaseAuthAdapterImpl>();

  InitialScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: _firebaseAuthAdapter.firebaseAuth.authStateChanges(),
      builder: (ctx, snapshot) {
        print(snapshot.connectionState);
        print(snapshot.data);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
