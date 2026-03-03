import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();

    if (kDebugMode) {
      const String host = "127.0.0.1";
      // Firestore
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
      // Functions
      FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
      // Storage
      await FirebaseStorage.instance.useStorageEmulator(host, 9199);
      // Auth
      // await FirebaseAuth.instance.useAuthEmulator(host, 9099);

      debugPrint("Connected to local Firebase Emulators at $host");
    }
  } catch (e) {
    debugPrint("Firebase init failed: $e");
  }
  runApp(const App());
}
