import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/pages/Login_screen.dart';
import 'package:recipe_app/pages/favorite.dart';
import 'package:recipe_app/pages/home.dart';
import 'package:recipe_app/pages/recipe.dart';
import 'package:recipe_app/pages/add_recipe.dart';
import 'package:recipe_app/pages/user_screen.dart';
import 'package:recipe_app/services/dialogflow.dart';
import 'package:recipe_app/services/firebase_noti.dart';
import 'package:recipe_app/services/local_noti.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNoti.initialize();
  await FirebaseNoti.initializeFCM();
  await DialogflowService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
