// Import the scripts that are required for Firebase Cloud Messaging
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

// Initialize Firebase
firebase.initializeApp({
  apiKey: "AIzaSyAU3Nfhzr6Qv-hKBdnHTF6-E6LbUgy94C4",
  authDomain: "mybellon-agent-v1.firebaseapp.com",
  databaseURL: "https://mybellon-agent-v1-default-rtdb.europe-west1.firebasedatabase.app",
  projectId: "mybellon-agent-v1",
  storageBucket: "mybellon-agent-v1.appspot.com",
  messagingSenderId: "1040016640643",
  appId: "1:1040016640643:web:917e5261f70bba57c769b6",
  measurementId: "G-QPW48LM2MM"
});

// Retrieve an instance of Firebase Messaging so that it can handle background messages
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // Customize notification here
  const notificationTitle = 'Background Message Title';
  const notificationOptions = {
    body: 'Background Message body.',
    icon: '/firebase-logo.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
