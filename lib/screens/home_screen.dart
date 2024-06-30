import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'job_posting_screen.dart';
import 'job_list_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyBellon Agent Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('job_posts')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final jobCount = snapshot.data!.docs.length;
                return Text('Number of job posts: $jobCount');
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('available', isEqualTo: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final availableUsers = snapshot.data!.docs;
                print("Available Users: ${availableUsers.length}");
                availableUsers.forEach((doc) {
                  print(
                      "User: ${doc['email']}, Available: ${doc['available']}");
                });
                return Column(
                  children: [
                    Text('Number of available users: ${availableUsers.length}'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: availableUsers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(availableUsers[index]['email']),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JobPostingScreen()),
                );
              },
              child: Text('Add Post'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JobListScreen()),
                );
              },
              child: Text('View Job List'),
            ),
          ],
        ),
      ),
    );
  }
}
