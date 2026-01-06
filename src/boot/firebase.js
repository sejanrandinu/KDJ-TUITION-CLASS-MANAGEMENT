// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBo-5Prs_OYXuSNSGg0d4bLHA30uRMBN5E",
  authDomain: "classmaster-e1117.firebaseapp.com",
  projectId: "classmaster-e1117",
  storageBucket: "classmaster-e1117.firebasestorage.app",
  messagingSenderId: "787477323058",
  appId: "1:787477323058:web:8fe1a8de2ab24dfeaacb2b",
  measurementId: "G-Y6CKVBVE1M"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

export { app, analytics };