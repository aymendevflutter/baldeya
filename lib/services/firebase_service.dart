import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/announcement.dart';
import '../models/rubrique.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Announcements
  Stream<List<Announcement>> getAnnouncements() {
    return _firestore
        .collection('announcements')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Announcement.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> addAnnouncement(Announcement announcement) async {
    try {
      await _firestore.collection('announcements').add(announcement.toMap());
    } catch (e) {
      print('Error adding announcement: $e');
      rethrow;
    }
  }

  Future<void> updateAnnouncement(String id, Announcement announcement) async {
    try {
      await _firestore
          .collection('announcements')
          .doc(id)
          .update(announcement.toMap());
    } catch (e) {
      print('Error updating announcement: $e');
      rethrow;
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    try {
      await _firestore.collection('announcements').doc(id).delete();
    } catch (e) {
      print('Error deleting announcement: $e');
      rethrow;
    }
  }

  // Rubriques
  Stream<List<Rubrique>> getRubriques() {
    return _firestore
        .collection('rubriques')
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Rubrique.fromFirestore(doc)).toList();
    });
  }

  Future<String> addRubrique(Rubrique rubrique) async {
    try {
      final docRef =
          await _firestore.collection('rubriques').add(rubrique.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error adding rubrique: $e');
      rethrow;
    }
  }

  Future<void> updateRubrique(String id, Rubrique rubrique) async {
    try {
      await _firestore
          .collection('rubriques')
          .doc(id)
          .update(rubrique.toFirestore());
    } catch (e) {
      print('Error updating rubrique: $e');
      rethrow;
    }
  }

  Future<void> deleteRubrique(String id) async {
    try {
      await _firestore.collection('rubriques').doc(id).delete();
    } catch (e) {
      print('Error deleting rubrique: $e');
      rethrow;
    }
  }

  // Content
  Stream<Map<String, dynamic>> getContent(String rubriqueId) {
    return _firestore
        .collection('rubriques')
        .doc(rubriqueId)
        .collection('content')
        .doc('current')
        .snapshots()
        .map((doc) => doc.data() ?? {});
  }

  Future<void> updateContent(
      String rubriqueId, Map<String, dynamic> content) async {
    try {
      await _firestore
          .collection('rubriques')
          .doc(rubriqueId)
          .collection('content')
          .doc('current')
          .set(content);
    } catch (e) {
      print('Error updating content: $e');
      rethrow;
    }
  }
}
