import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late String email;
  late String password;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
      _firebaseMessaging.subscribeToTopic('job_posts');
    }).catchError((error) {
      print("Error getting FCM token: $error");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title ?? ''),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body ?? '')],
                ),
              ),
            );
          },
        );
      }
    });
  }

  void _requestPermissions() {
    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyBellon Agent App'), // App Title
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  final user = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (user != null) {
                    await _firestore.collection('users').doc(email).set({
                      // Use email as document ID
                      'email': email,
                      'available': false,
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen()), // Navigate to HomeScreen
                    );
                  }
                } catch (e) {
                  setState(() {
                    errorMessage = e.toString();
                  });
                }
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen()), // Navigate to HomeScreen
                    );
                  }
                } catch (e) {
                  setState(() {
                    errorMessage = e.toString();
                  });
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 24.0),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
