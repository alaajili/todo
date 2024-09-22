import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/welcome_screen.dart';
import 'package:todo_app/theme/theme.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: "AIzaSyBRUyuTgyHpTtPZOrnI-vn28m94rwPm5aE",
      authDomain: "todo-app-76e41.firebaseapp.com",
      projectId: "todo-app-76e41",
      storageBucket: "todo-app-76e41.appspot.com",
      messagingSenderId: "907121414361",
      appId: "1:907121414361:web:7e321401652343cd676ec8"
    ));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightMode,
      home: const WelcomeScreen(),
    );
  }
}
