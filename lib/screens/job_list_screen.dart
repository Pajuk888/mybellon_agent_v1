import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('job_posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final jobPosts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobPosts.length,
            itemBuilder: (context, index) {
              final job = jobPosts[index];
              return ListTile(
                title: Text(job['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: ${job['description']}'),
                    Text('Pay Rate: ${job['pay_rate']}'),
                    Text('Posted on: ${job['timestamp'].toDate()}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
