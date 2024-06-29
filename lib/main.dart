import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAU3Nfhzr6Qv-hKBdnHTF6-E6LbUgy94C4',
      authDomain: 'mybellon-agent-v1.firebaseapp.com',
      projectId: 'mybellon-agent-v1',
      storageBucket: 'mybellon-agent-v1.appspot.com',
      messagingSenderId: '1040016640643',
      appId: '1:1040016640643:web:917e5261f70bba57c769b6',
      measurementId: 'G-QPW48LM2MM',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBellon Agent',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
