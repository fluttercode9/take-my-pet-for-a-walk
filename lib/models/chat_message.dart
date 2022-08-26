import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String userId;
  final DateTime date;
  final String text;
  final String? imageUrl;

  ChatMessage({
    required this.imageUrl,
    required this.userId,
    required this.date,
    required this.text,
  });

  factory ChatMessage.fromFirebase(Map<String, dynamic> json) {
    return ChatMessage(
        userId: json['userId'],
        date: json['date'].toDate(),
        text: json['text'],
        imageUrl: json['imageUrl']);
  }

  Map<String, dynamic> toMap() {
    return {"userId": userId, "date": Timestamp.fromDate(date), "text": text};
  }
}
