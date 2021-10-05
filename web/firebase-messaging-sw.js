importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");
firebase.initializeApp({
    apiKey: "AIzaSyDgPC7YvhIZT2CxrAZKIZBYWGbqAiJqh_Q",
    authDomain: "fntat-deeb5.firebaseapp.com",
    projectId: "fntat-deeb5",
    storageBucket: "fntat-deeb5.appspot.com",
    messagingSenderId: "832867614186",
    appId: "1:832867614186:web:36ae04561f18b352a28693",
    measurementId: "G-YVJZXL1RE6"
});
const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});