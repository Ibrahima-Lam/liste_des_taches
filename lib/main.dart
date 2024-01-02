import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:liste_des_taches/firebase_options.dart';
import 'package:liste_des_taches/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

final Color bleu = Color.fromARGB(255, 10, 41, 242);

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage());
  }
}
