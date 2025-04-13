import 'package:ballauto/model/user_profile.dart';
import 'package:ballauto/services/user_service.dart';
import 'package:flutter/material.dart';
import '../home/home.dart'; // เปลี่ยนจาก MainLayout เป็น Home

class FormProfileScreen extends StatefulWidget {
  const FormProfileScreen({super.key});

  @override
  State<FormProfileScreen> createState() => _FormProfileScreenState();
}

class _FormProfileScreenState extends State<FormProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedGender;
  String? _selectedBloodType;
  final TextEditingController _diseaseController = TextEditingController();
  final TextEditingController _allergyController = TextEditingController();

  final List<String> _genders = ['ชาย', 'หญิง', 'อื่นๆ'];
  final List<String> _bloodTypes = ['A', 'B', 'AB', 'O'];

  final UserService _userService = UserService();

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final userProfile = UserProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: _selectedGender,
        bloodType: _selectedBloodType,
        disease: _diseaseController.text.trim(),
        allergy: _allergyController.text.trim(),
      );

      try {
        await _userService.saveUserProfile(userProfile);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ!')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home()), // เปลี่ยนเป็น Home
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('กรอกข้อมูลส่วนตัว'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อ-นามสกุล',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อ-นามสกุล';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'เบอร์โทรศัพท์',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกเบอร์โทรศัพท์';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง (10 หลัก)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'เพศ',
                    border: OutlineInputBorder(),
                  ),
                  items: _genders
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'กรุณาเลือกเพศ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedBloodType,
                  decoration: const InputDecoration(
                    labelText: 'หมู่เลือด',
                    border: OutlineInputBorder(),
                  ),
                  items: _bloodTypes
                      .map((bloodType) => DropdownMenuItem(
                            value: bloodType,
                            child: Text(bloodType),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBloodType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'กรุณาเลือกหมู่เลือด';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _diseaseController,
                  decoration: const InputDecoration(
                    labelText: 'โรคประจำตัว',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _allergyController,
                  decoration: const InputDecoration(
                    labelText: 'การแพ้ยา',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'บันทึกข้อมูล',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}