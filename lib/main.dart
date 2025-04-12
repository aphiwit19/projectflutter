import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Sceen/home/home.dart';
import 'Sceen/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signOut(); // ล็อกเอาท์ผู้ใช้ทั้งหมด (เพื่อทดสอบ)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // ผู้ใช้ล็อกอินแล้ว -> ไปหน้า Home
            return const Home();
          } else {
            // ผู้ใช้ยังไม่ได้ล็อกอิน -> ไปหน้า Login
            return const LoginScreen();
          }
        },
      ),
    );
  }
}