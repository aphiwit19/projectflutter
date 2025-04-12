import 'package:flutter/material.dart'; // นำเข้า Material Design Widgets

// CustomBottomNavigationBar เป็น Widget สำหรับแถบด้านล่าง
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex; // สถานะของไอคอนที่ถูกเลือก
  final Function(int) onTap; // ฟังก์ชันที่เรียกเมื่อผู้ใช้กดไอคอน

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // กำหนดสถานะของไอคอนที่ถูกเลือก
      onTap: onTap, // ฟังก์ชันที่เรียกเมื่อผู้ใช้กดไอคอน
      selectedItemColor: Colors.redAccent, // สีของไอคอนที่ถูกเลือก
      unselectedItemColor: Colors.grey, // สีของไอคอนที่ไม่ได้เลือก
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home), // ไอคอนหน้าแรก
          label: 'หน้าแรก',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat), // ไอคอนแชท
          label: 'แชท',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu), // ไอคอนเมนู
          label: 'เมนู',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.contacts), // ไอคอนผู้ติดต่อ
          label: 'ผู้ติดต่อ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person), // ไอคอนโปรไฟล์
          label: 'โปรไฟล์',
        ),
      ],
    );
  }
}