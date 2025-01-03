
import 'package:firebase_core/firebase_core.dart';
import 'package:backoffice52switch/utils/env_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:backoffice52switch/modules/shared/services/logger_config.dart';
import 'package:backoffice52switch/firebase_options.dart';
class FirebaseConfig {
  // Method to load Firebase configuration dynamically
  static Future<void> loadFirebaseConfig() async {
    // Initialize Firebase with the dynamically generated DefaultFirebaseOptions
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
    LoggerConfig().logger.i("Firebase initialized with DefaultFirebaseOptions.");
    if (EnvConfig.useEmulator){  // Initialize Firebase Emulator if required
      FirebaseAuth.instance.useAuthEmulator(EnvConfig.hostAddress, EnvConfig.emulatorPort);
      print(EnvConfig.hostAddress);
      print(EnvConfig.emulatorPort);
      }
  }
}
