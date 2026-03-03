import { initializeApp } from "firebase/app";
import { getFirestore, connectFirestoreEmulator } from "firebase/firestore";
import { getStorage, connectStorageEmulator } from "firebase/storage";
import { getAuth, connectAuthEmulator } from "firebase/auth";
import { getFunctions, connectFunctionsEmulator } from "firebase/functions";

// Replace with your Firebase Web App Config.
// You can find this in your Firebase Console under "Project Settings" -> "General" -> "Your apps" -> "Web app".
const firebaseConfig = {
    apiKey: "demo-key", // Used for local emulator
    authDomain: "demo-no-project.firebaseapp.com",
    projectId: "demo-no-project",
    storageBucket: "demo-no-project.appspot.com",
    messagingSenderId: "123456789",
    appId: "1:123456789:web:abcdef"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const storage = getStorage(app);
export const auth = getAuth(app);
export const functions = getFunctions(app);

// CONNECT TO EMULATORS IN DEVELOPMENT
if (location.hostname === "localhost" || location.hostname === "127.0.0.1") {
    console.log("Connecting to local Firebase emulators...");
    connectFirestoreEmulator(db, '127.0.0.1', 8080);
    connectStorageEmulator(storage, '127.0.0.1', 9199);
    connectFunctionsEmulator(functions, '127.0.0.1', 5001);
    connectAuthEmulator(auth, 'http://127.0.0.1:9099');
}
