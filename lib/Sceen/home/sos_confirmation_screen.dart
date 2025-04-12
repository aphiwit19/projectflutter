import 'package:flutter/material.dart';
import 'dart:async'; // สำหรับ Timer

class SosConfirmationScreen extends StatefulWidget {
  const SosConfirmationScreen({super.key});

  @override
  State<SosConfirmationScreen> createState() => _SosConfirmationScreenState();
}

class _SosConfirmationScreenState extends State<SosConfirmationScreen> {
  int _countdown = 5; // ตั้งค่าเริ่มต้นเป็น 10 วินาที
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown(); // เริ่มการนับถอยหลังเมื่อเปิดหน้า
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--; // ลดค่าทีละ 1 ทุกวินาที
        });
      } else {
        _timer.cancel(); // หยุด Timer เมื่อถึง 0
        Navigator.pop(context);// กลับไปยังหน้า Home
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // ยกเลิก Timer เมื่อปิดหน้า
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ), // เพิ่มระยะห่างด้านซ้ายและขวา
              child: Text(
                "ระบบจะแจ้งเหตุฉุกเฉินเมื่อหมดเวลานับถอยหลังหมด",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$_countdown', // แสดงตัวเลขนับถอยหลัง
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(230, 70, 70, 1),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // ย้อนกลับไปยังหน้า Home
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "ยกเลิก",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
