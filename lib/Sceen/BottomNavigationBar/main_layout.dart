// import 'package:ballauto/Sceen/contact/contacts_screen.dart';
// import 'package:flutter/material.dart';
// import 'bottom_navigation_bar.dart';
// import '../home/home.dart';
// import '../chats/chat_screen.dart';
// import '../menu/menu_screen.dart';
// import '../profile/profile_screen.dart';

// class MainLayout extends StatefulWidget {
//   const MainLayout({super.key});

//   @override
//   State<MainLayout> createState() => _MainLayoutState();
// }

// class _MainLayoutState extends State<MainLayout> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     const Home(),
//     const ChatScreen(),
//     const MenuScreen(),
//     const ContactsScreen(),
//     const ProfileScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true, // ให้เนื้อหาขยายไปถึงด้านล่าง ไม่ถูกบังโดย bottomNavigationBar
//       body: _pages[_currentIndex],
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }