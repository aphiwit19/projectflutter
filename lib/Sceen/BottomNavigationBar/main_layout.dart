import 'package:ballauto/Sceen/contact/contacts_screen.dart';// นำเข้าหน้าผู้ติดต่อ
import 'package:flutter/material.dart'; // นำเข้า Material Design Widgets
import 'bottom_navigation_bar.dart'; // นำเข้า CustomBottomNavigationBar สำหรับแถบด้านล่าง
import '../home/home.dart'; // นำเข้าหน้า Home
import '../chats/chat_screen.dart'; // นำเข้าหน้า Chat
import '../menu/menu_screen.dart'; // นำเข้าหน้า Menu
import '../profile/profile_screen.dart'; // นำเข้าหน้า Profile

// MainLayout เป็นโครงสร้างหลักของแอปที่มี Bottom Navigation Bar
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // ตัวแปร _currentIndex ใช้เก็บสถานะของหน้าใน Bottom Navigation Bar
  int _currentIndex = 0;

  // รายการหน้าทั้งหมดที่จะแสดงในแอป
  final List<Widget> _pages = [
    const Home(), // หน้าแรก
    const ChatScreen(), // หน้าแชท
    const MenuScreen(), // หน้าเมนู
    const ContactsScreen(), // หน้าผู้ติดต่อ
    const ProfileScreen(), // หน้าโปรไฟล์
  ];

  // ฟังก์ชัน _onItemTapped ใช้สำหรับเปลี่ยนหน้าเมื่อผู้ใช้กดไอคอนใน Bottom Navigation Bar
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // อัปเดต _currentIndex ตามไอคอนที่ถูกกด
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body จะแสดงหน้าที่ตรงกับ _currentIndex
      body: _pages[_currentIndex],

      // bottomNavigationBar คือ CustomBottomNavigationBar ที่แสดงแถบด้านล่าง
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex, // ส่งสถานะปัจจุบันไปยัง Bottom Navigation Bar
        onTap: _onItemTapped, // ฟังก์ชันที่เรียกเมื่อผู้ใช้กดไอคอน
      ),
    );
  }
}