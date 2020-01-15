import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sih_test/services/auth_widget.dart';
import 'package:sih_test/services/firebase_auth_service.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthService>(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWidget(),
      ),
      create: (_) => FirebaseAuthService(),
    );
  }
}
