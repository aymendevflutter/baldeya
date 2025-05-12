import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final Map<String, String> title;
  final Map<String, String> content;
  final String? imageUrl;
  final DateTime date;
  final bool isUrgent;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.date,
    this.isUrgent = false,
  });

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      title: Map<String, String>.from(data['title'] ?? {}),
      content: Map<String, String>.from(data['content'] ?? {}),
      imageUrl: data['imageUrl'],
      date: (data['date'] as Timestamp).toDate(),
      isUrgent: data['isUrgent'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'date': Timestamp.fromDate(date),
      'isUrgent': isUrgent,
    };
  }
}
