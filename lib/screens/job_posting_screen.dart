import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobPostingScreen extends StatefulWidget {
  @override
  _JobPostingScreenState createState() => _JobPostingScreenState();
}

class _JobPostingScreenState extends State<JobPostingScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String title;
  late String description;
  late String payRate;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post a Job'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                title = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter job title',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              onChanged: (value) {
                description = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter job description',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              onChanged: (value) {
                payRate = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter pay rate',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  final user = _auth.currentUser;
                  if (user != null) {
                    await _firestore.collection('jobs').add({
                      'title': title,
                      'description': description,
                      'payRate': payRate,
                      'postedBy': user.email,
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                    setState(() {
                      errorMessage = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Job posted successfully!')),
                    );
                  }
                } catch (e) {
                  setState(() {
                    errorMessage = e.toString();
                  });
                }
              },
              child: Text('Post Job'),
            ),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
