import 'package:flutter/material.dart'; // นำเข้า Material Design Widgets
import 'package:firebase_core/firebase_core.dart'; // นำเข้า Firebase Core สำหรับการเริ่มต้น Firebase
import 'package:firebase_auth/firebase_auth.dart'; // นำเข้า Firebase Auth สำหรับการจัดการการล็อกอิน
import 'Sceen/BottomNavigationBar/main_layout.dart'; // นำเข้า MainLayout ซึ่งเป็นโครงสร้างหลักของแอป
import 'Sceen/auth/login_screen.dart'; // นำเข้าหน้า Login สำหรับผู้ใช้ที่ยังไม่ได้ล็อกอิน

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // เริ่มต้น Flutter Binding
  await Firebase.initializeApp(); // เริ่มต้น Firebase
  runApp(const MyApp()); // เรียกใช้งานแอปพลิเคชัน
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ซ่อนแถบ Debug
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // ฟังการเปลี่ยนแปลงสถานะการล็อกอินของผู้ใช้
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // แสดง Loading หากกำลังตรวจสอบสถานะการล็อกอิน
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // หากผู้ใช้ล็อกอินแล้ว -> ไปที่ MainLayout
            return const MainLayout();
          } else {
            // หากผู้ใช้ยังไม่ได้ล็อกอิน -> ไปที่ LoginScreen
            return const LoginScreen();
          }
        },
      ),
    );
  }
}