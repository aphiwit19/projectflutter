import 'package:ballauto/Sceen/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:ballauto/Sceen/chats/conversation_screen.dart';
import 'package:ballauto/model/conversation.dart';
import 'package:ballauto/model/user_profile.dart';
import 'package:ballauto/services/chat_service.dart';
import 'package:ballauto/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final ChatService chatService = ChatService();
    final UserService userService = UserService();

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('กรุณาล็อกอินก่อน')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'แชท',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(230, 70, 70, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatService.getConversations(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ยังไม่มีข้อความ'));
          }

          final conversations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversationData = Conversation.fromMap(
                  conversations[index].data() as Map<String, dynamic>);
              final conversationId = conversations[index].id;

              // หา UID ของผู้ติดต่อ (คนที่ไม่ใช่ผู้ใช้ปัจจุบัน)
              final contactUid = conversationData.participants
                  .firstWhere((uid) => uid != user.uid);

              return FutureBuilder<UserProfile?>(
                future: userService.getUserProfile(contactUid),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('กำลังโหลด...'),
                    );
                  }
                  if (userSnapshot.hasError || !userSnapshot.hasData) {
                    return ListTile(
                      title: Text('ผู้ใช้ $contactUid'),
                      subtitle: Text(conversationData.lastMessage),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConversationScreen(
                              contactUid: contactUid,
                              contactName: 'ผู้ใช้ $contactUid',
                            ),
                          ),
                        );
                      },
                    );
                  }

                  final contactName = userSnapshot.data!.name;

                  return ListTile(
                    title: Text(contactName),
                    subtitle: Text(conversationData.lastMessage),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationScreen(
                            contactUid: contactUid,
                            contactName: contactName,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}