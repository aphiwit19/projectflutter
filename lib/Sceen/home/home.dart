import 'package:flutter/material.dart';
import 'sos_confirmation_screen.dart'; // นำเข้าหน้า SOS Confirmation

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),// เพิ่มระยะห่างด้านซ้ายและขวา
              child: Text(
                "คุณต้องการความช่วยเหลือฉุกเฉิน ใช่ไหม?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 80),
            GestureDetector(
              onTap: () {
                // นำทางไปยังหน้า SOS Confirmation
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SosConfirmationScreen(),
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 216, 215, 1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 135, 133, 1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(230, 70, 70, 1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    "SOS",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 80),
            Text(
              "กดปุ่ม SOS เพื่อขอความช่วยเหลือ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
