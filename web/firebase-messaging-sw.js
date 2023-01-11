importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: 'AIzaSyB4utetA217otmnx7HVlxHYoeqIR7DwXkc',
    appId: '1:143834371075:web:66f343814cb1f380d42a36',
    messagingSenderId: '143834371075',
    projectId: 'pssi-bcfac',
    authDomain: 'pssi-bcfac.firebaseapp.com',
    storageBucket: 'pssi-bcfac.appspot.com',
    measurementId: 'G-54NMXHHDEP',
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});