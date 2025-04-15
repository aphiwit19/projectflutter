import 'package:ballauto/Sceen/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:ballauto/Sceen/contact/add_contact_screen.dart';
import 'package:ballauto/Sceen/chats/conversation_screen.dart'; // เพิ่ม import นี้
import 'package:ballauto/model/contact.dart';
import 'package:ballauto/services/contact_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final ContactService contactService = ContactService();

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('กรุณาล็อกอินก่อน')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายชื่อผู้ติดต่อ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(230, 70, 70, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('contacts')
            .orderBy('addedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ยังไม่มีผู้ติดต่อ'));
          }

          final contacts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contactData = Contact.fromMap(contacts[index].data() as Map<String, dynamic>);
              final contactUid = contacts[index].id;

              return ListTile(
                title: Text(contactData.name),
                subtitle: Text(contactData.phone),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (value) async {
                    if (value == 'delete') {
                      await contactService.deleteContact(contactUid);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ลบผู้ติดต่อสำเร็จ')),
                      );
                    } else if (value == 'chat') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationScreen(
                            contactUid: contactUid,
                            contactName: contactData.name,
                          ),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'chat',
                      child: ListTile(
                        leading: Icon(Icons.chat, color: Colors.red),
                        title: Text('เริ่มแชท'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('ลบ'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: CustomBottomNavigationBar(
          currentIndex: 3,
          onTap: (index) {},
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddContactScreen()),
            );
          },
          backgroundColor: const Color.fromRGBO(230, 70, 70, 1),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}