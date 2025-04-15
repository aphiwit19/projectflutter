import 'package:cloud_firestore/cloud_firestore.dart';
class Conversation {
  final List<String> participants;
  final String lastMessage;
  final DateTime? lastMessageTimestamp;
  final String lastMessageSenderId;

  Conversation({
    required this.participants,
    required this.lastMessage,
    this.lastMessageTimestamp,
    required this.lastMessageSenderId,
  });

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTimestamp: (map['lastMessageTimestamp'] as Timestamp?)?.toDate(),
      lastMessageSenderId: map['lastMessageSenderId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp != null
          ? Timestamp.fromDate(lastMessageTimestamp!)
          : FieldValue.serverTimestamp(),
      'lastMessageSenderId': lastMessageSenderId,
    };
  }
}