import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_profile.dart';

class UserService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  // ฟังก์ชันบันทึกข้อมูลผู้ใช้  บันทึกข้อมูลโปรไฟล์ผู้ใช้ลงใน Firestore (เช่น ชื่อ, เบอร์โทร)
  Future<void> saveUserProfile(UserProfile userProfile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _userCollection.doc(user.uid).set(userProfile.toMap());
      } else {
        throw Exception('ไม่พบผู้ใช้ที่ล็อกอิน');
      }
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e');
    }
  }

  // ฟังก์ชันดึงข้อมูลผู้ใช้ด้วย UID  ดึงข้อมูลโปรไฟล์ผู้ใช้จาก UID (ใช้ในหน้าโปรไฟล์)
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _userCollection.doc(userId).get();
      if (doc.exists) {
        return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการดึงข้อมูล: $e');
    }
  }

  // ฟังก์ชันค้นหาผู้ใช้ด้วยเบอร์โทรศัพท์  findUserByPhone: ค้นหาข้อมูลผู้ใช้จากเบอร์โทรศัพท์ (ใช้เมื่อเพิ่มผู้ติดต่อ)
  Future<UserProfile?> findUserByPhone(String phone) async {
    try {
      final query = await _userCollection.where('phone', isEqualTo: phone).get();
      if (query.docs.isNotEmpty) {
        return UserProfile.fromMap(query.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการค้นหาผู้ใช้: $e');
    }
  }

  // ฟังก์ชันดึง UID จากเบอร์โทรศัพท์ ดึง UID จากเบอร์โทรศัพท์ (ใช้เพื่อเก็บผู้ติดต่อใน Firestore)
  Future<String?> getUidByPhone(String phone) async {
    try {
      final query = await _userCollection.where('phone', isEqualTo: phone).get();
      if (query.docs.isNotEmpty) {
        return query.docs.first.id; // คืนค่า UID (Document ID)
      }
      return null;
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการค้นหา UID: $e');
    }
  }
}