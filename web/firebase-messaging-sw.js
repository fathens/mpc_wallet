importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyC0WzymNUXYOp-4dxw61IiajiIGXCJ0r9s",
  authDomain: "mpc-wallet-c5a4b.firebaseapp.com",
  projectId: "mpc-wallet-c5a4b",
  storageBucket: "mpc-wallet-c5a4b.appspot.com",
  messagingSenderId: "904340595483",
  appId: "1:904340595483:web:bdd6318f1f796b36ca69be",
  measurementId: "G-FETTJVP0B6"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});