import 'package:flutter/material.dart';
import 'package:backoffice52switch/modules/shared/services/firebase_config.dart';
import 'package:backoffice52switch/modules/authentication/auth_service.dart';
import 'package:backoffice52switch/modules/authentication/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await FirebaseConfig.loadFirebaseConfig();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Attendance App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        debugShowCheckedModeBanner: false,
        locale: const Locale('ko', 'KR'), // Set default language to Korean
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('ko', 'KR'), // Korean
        ],
        home: AuthScreen(),// Initial screen is LoginScreen
        routes: {
          '/login': (context) => AuthScreen(),
        },
      ),
    );
  }
}


