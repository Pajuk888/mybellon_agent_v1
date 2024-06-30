const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnNewJobPost = functions.firestore
    .document('job_posts/{jobId}')
    .onCreate((snap, context) => {
        const newValue = snap.data();

        const payload = {
            notification: {
                title: 'New Job Posted!',
                body: `A new job has been posted: ${newValue.title}`,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };

        return admin.messaging().sendToTopic('job_posts', payload)
            .then((response) => {
                console.log('Notification sent successfully:', response);
            })
            .catch((error) => {
                console.log('Notification sending failed:', error);
            });
    });
