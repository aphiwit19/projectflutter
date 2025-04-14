//ดึงข้อมูลผู้ติดต่อจาก Firebase และ เพิ่ม หรือ ลบผู้ติดต่อใน Firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/contact.dart';
import '../model/user_profile.dart';
import 'user_service.dart';

class ContactService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final UserService _userService = UserService();

  // เพิ่มผู้ติดต่อ
  Future<void> addContact(String phone) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('กรุณาล็อกอินก่อน');
      }

      // ค้นหาผู้ใช้ด้วยเบอร์โทร
      final contactUser = await _userService.findUserByPhone(phone);
      if (contactUser == null) {
        throw Exception('ไม่พบผู้ใช้ที่มีเบอร์โทรนี้');
      }

      // ดึง UID ของผู้ติดต่อ
      final contactUid = await _userService.getUidByPhone(phone);
      if (contactUid == null) {
        throw Exception('เกิดข้อผิดพลาดในการค้นหาผู้ใช้');
      }

      // ตรวจสอบว่าไม่ใช่ตัวเอง
      if (contactUid == user.uid) {
        throw Exception('คุณไม่สามารถเพิ่มตัวเองเป็นผู้ติดต่อได้');
      }

      // สร้าง Contact object
      final contact = Contact(
        name: contactUser.name,
        phone: contactUser.phone,
        addedAt: DateTime.now(),
      );

      // เพิ่มผู้ติดต่อใน Firestore
      await _userCollection
          .doc(user.uid)
          .collection('contacts')
          .doc(contactUid)
          .set(contact.toMap());
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการเพิ่มผู้ติดต่อ: $e');
    }
  }

  // ดึงรายชื่อผู้ติดต่อ
  Future<List<Contact>> getContacts() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('กรุณาล็อกอินก่อน');
      }

      final query = await _userCollection
          .doc(user.uid)
          .collection('contacts')
          .orderBy('addedAt', descending: true)
          .get();

      return query.docs
          .map((doc) => Contact.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการดึงรายชื่อผู้ติดต่อ: $e');
    }
  }

  // ลบผู้ติดต่อ
  Future<void> deleteContact(String contactUid) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('กรุณาล็อกอินก่อน');
      }

      await _userCollection
          .doc(user.uid)
          .collection('contacts')
          .doc(contactUid)
          .delete();
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการลบผู้ติดต่อ: $e');
    }
  }

  // ตรวจสอบว่าเบอร์โทรศัพท์มีอยู่ในระบบหรือไม่
Future<bool> checkUserExists(String phone) async {
  try {
    // ค้นหาผู้ใช้ด้วยเบอร์โทร
    final querySnapshot = await _userCollection
        .where('phone', isEqualTo: phone)
        .get();

    // ถ้ามีเอกสารในผลลัพธ์ แสดงว่าผู้ใช้มีอยู่ในระบบ
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    throw Exception('เกิดข้อผิดพลาดในการตรวจสอบผู้ใช้: $e');
  }
}
}