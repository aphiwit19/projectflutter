import 'package:ballauto/Sceen/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:ballauto/Sceen/profile/edit_profile_screen.dart';
import 'package:ballauto/model/user_profile.dart';
import 'package:ballauto/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ballauto/Sceen/auth/login_screen.dart';
import 'package:flutter/services.dart'; // สำหรับการคัดลอก
import 'package:clipboard/clipboard.dart'; // สำหรับ package clipboard


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<UserProfile?> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userService = UserService();
        return await userService.getUserProfile(user.uid);
      }
    } catch (e) {
      debugPrint('ข้อผิดพลาดในการดึงข้อมูล: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ข้อมูลผู้ใช้งาน',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(230, 70, 70, 1),
      ),
      body: FutureBuilder<UserProfile?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('ไม่พบข้อมูลผู้ใช้'));
          }

          final userData = snapshot.data!;

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ชื่อ: ${userData.name}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'เบอร์โทร: ${userData.phone}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'กรุ๊ปเลือด: ${userData.bloodType ?? 'ไม่ระบุ'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'โรคประจำตัว: ${userData.disease}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'เพศ: ${userData.gender ?? 'ไม่ระบุ'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'แพ้ยา: ${userData.allergy}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(userProfile: userData),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'แก้ไขข้อมูล',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        debugPrint('ออกจากระบบสำเร็จ');
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      } catch (e) {
                        debugPrint('ข้อผิดพลาด: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('เกิดข้อผิดพลาดในการออกจากระบบ: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'ออกจากระบบ',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {},
      ),
    );
  }
}