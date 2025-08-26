// src/firebase.ts
import { initializeApp } from "firebase/app";
import { getAnalytics, isSupported } from "firebase/analytics";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

// Your Firebase configuration
const firebaseConfig = {
  apiKey: process.env.REACT_APP_FIREBASE_API_KEY || "AIzaSyDkWDD8fXAhExIFV42hnv-neR-GmfzyFQo",
  authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN || "web-based-85961.firebaseapp.com",
  projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID || "web-based-85961",
  storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET || "web-based-85961.appspot.com",
  messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER_ID || "599570934816",
  appId: process.env.REACT_APP_FIREBASE_APP_ID || "1:599570934816:web:00a16912d53b879069a045",
  measurementId: process.env.REACT_APP_FIREBASE_MEASUREMENT_ID || "G-ZYYHST44XB"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Optional: Analytics only works in browser + production
let analytics: ReturnType<typeof getAnalytics> | null = null;
if (typeof window !== "undefined") {
  isSupported().then((yes) => {
    if (yes) analytics = getAnalytics(app);
  });
}

// Export Firebase services
export const auth = getAuth(app);
export const db = getFirestore(app);
export { analytics };
