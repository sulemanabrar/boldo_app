import 'package:boldo/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/boldo_app.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? startupError;
  var firebaseReady = false;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );    firebaseReady = true;
  } catch (error) {
    startupError = error;
  }

  runApp(
    ProviderScope(
      child: BolDoApp(
        firebaseReady: firebaseReady,
        startupError: startupError,
      ),
    ),
  );
}
