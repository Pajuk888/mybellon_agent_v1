import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class JobPostingScreen extends StatefulWidget {
  @override
  _JobPostingScreenState createState() => _JobPostingScreenState();
}

class _JobPostingScreenState extends State<JobPostingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _payRateController =
      TextEditingController(); // New Controller for Pay Rate

  void addJobPost() async {
    try {
      await FirebaseFirestore.instance.collection('job_posts').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'pay_rate': _payRateController.text, // Adding Pay Rate
        'timestamp': FieldValue.serverTimestamp(),
      });
      showNotification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job posted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post job: $e')),
      );
    }
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'job_post_channel', // channel ID
      'Job Post Notifications', // channel name
      channelDescription:
          'Notification channel for job posts', // channel description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      sound: RawResourceAndroidNotificationSound(
          'notification'), // sound file in res/raw
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // notification ID
      'New Job Posted',
      'A new job has been posted: ${_titleController.text}',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post a Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Job Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Job Description'),
            ),
            TextField(
              controller: _payRateController,
              decoration:
                  InputDecoration(labelText: 'Pay Rate'), // New Pay Rate Field
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addJobPost,
              child: Text('Post Job'),
            ),
          ],
        ),
      ),
    );
  }
}
