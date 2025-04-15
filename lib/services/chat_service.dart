import 'package:ballauto/model/conversation.dart';
import 'package:ballauto/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // สร้าง conversationId
  String generateConversationId(String senderUid, String receiverUid) {
    List<String> uids = [senderUid, receiverUid]..sort();
    return '${uids[0]}_${uids[1]}';
  }

  // ส่งข้อความ
  Future<void> sendMessage(String senderUid, String receiverUid, String message) async {
    try {
      String conversationId = generateConversationId(senderUid, receiverUid);

      // บันทึกข้อความ
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        'senderId': senderUid,
        'receiverId': receiverUid,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      // อัปเดตข้อมูล conversation
      await _firestore.collection('conversations').doc(conversationId).set({
        'participants': [senderUid, receiverUid],
        'lastMessage': message,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'lastMessageSenderId': senderUid,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการส่งข้อความ: $e');
    }
  }

  // ดึงข้อความ
  Stream<QuerySnapshot> getMessages(String senderUid, String receiverUid) {
    String conversationId = generateConversationId(senderUid, receiverUid);
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getConversations(String userUid) {
  return _firestore
      .collection('conversations')
      .where('participants', arrayContains: userUid)
      .orderBy('lastMessageTimestamp', descending: true)
      .snapshots();
}
}