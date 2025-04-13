import 'package:ballauto/model/user_profile.dart';
import 'package:ballauto/services/user_service.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile userProfile;

  const EditProfileScreen({super.key, required this.userProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? _selectedGender;
  String? _selectedBloodType;
  late TextEditingController _diseaseController;
  late TextEditingController _allergyController;

  final List<String> _genders = ['ชาย', 'หญิง', 'อื่นๆ'];
  final List<String> _bloodTypes = ['A', 'B', 'AB', 'O'];

  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    // ตั้งค่าเริ่มต้นจากข้อมูลที่มีอยู่
    _nameController = TextEditingController(text: widget.userProfile.name);
    _phoneController = TextEditingController(text: widget.userProfile.phone);
    _selectedGender = widget.userProfile.gender;
    _selectedBloodType = widget.userProfile.bloodType;
    _diseaseController = TextEditingController(text: widget.userProfile.disease);
    _allergyController = TextEditingController(text: widget.userProfile.allergy);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _diseaseController.dispose();
    _allergyController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = UserProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: _selectedGender,
        bloodType: _selectedBloodType,
        disease: _diseaseController.text.trim(),
        allergy: _allergyController.text.trim(),
      );

      try {
        await _userService.saveUserProfile(updatedProfile);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('แก้ไขข้อมูลส่วนตัวสําเร็จ!')),
        );
        Navigator.pop(context); // กลับไปหน้า ProfileScreen
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
        title: const Text('แก้ไขข้อมูลส่วนตัว'),
        backgroundColor: const Color.fromRGBO(230, 70, 70, 1),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
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
                      backgroundColor: Colors.green,
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
                      style: TextStyle(fontSize: 18, color: Colors.white),
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