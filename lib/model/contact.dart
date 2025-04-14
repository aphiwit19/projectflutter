//เก็บข้อมูลผู้ติดต่อ เช่น ชื่อ, เบอร์โทรศัพท์, ความสัมพันธ์

import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String name;
  final String phone;
  final DateTime? addedAt;

  Contact({
    required this.name,
    required this.phone,
    this.addedAt,
  });

  // แปลง Contact เป็น Map เพื่อเก็บใน Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'addedAt': addedAt != null ? Timestamp.fromDate(addedAt!) : null,
    };
  }

  // สร้าง Contact จาก Map ที่ดึงมาจาก Firestore
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      addedAt: map['addedAt'] != null
          ? (map['addedAt'] as Timestamp).toDate()
          : null,
    );
  }
}