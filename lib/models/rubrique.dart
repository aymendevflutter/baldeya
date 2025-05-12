import 'package:cloud_firestore/cloud_firestore.dart';

class Rubrique {
  final String id;
  final Map<String, String> title;
  final Map<String, String> description;
  final String icon;
  final int order;
  final Map<String, String> content;
  final String? parentId;

  Rubrique({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.order = 0,
    this.content = const {},
    this.parentId,
  });

  factory Rubrique.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Rubrique(
      id: doc.id,
      title: Map<String, String>.from(data['title'] ?? {}),
      description: Map<String, String>.from(data['description'] ?? {}),
      icon: data['icon'] ?? 'folder',
      order: data['order'] ?? 0,
      content: Map<String, String>.from(data['content'] ?? {}),
      parentId: data['parentId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'order': order,
      'content': content,
      if (parentId != null) 'parentId': parentId,
    };
  }
}
