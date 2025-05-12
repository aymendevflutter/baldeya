import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rubrique.dart';
import '../models/announcement.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Rubrique>> getRubriques() async {
    final snapshot = await _firestore.collection('rubriques').get();
    return snapshot.docs.map((doc) => Rubrique.fromFirestore(doc)).toList();
  }

  Future<List<Announcement>> getAnnouncements() async {
    final snapshot = await _firestore.collection('announcements').get();
    return snapshot.docs.map((doc) => Announcement.fromFirestore(doc)).toList();
  }

  Future<void> addRubrique(Rubrique rubrique) async {
    await _firestore.collection('rubriques').add(rubrique.toFirestore());
  }

  Future<void> addAnnouncement(Announcement announcement) async {
    await _firestore.collection('announcements').add(announcement.toMap());
  }

  Future<void> updateRubrique(Rubrique rubrique) async {
    await _firestore
        .collection('rubriques')
        .doc(rubrique.id)
        .update(rubrique.toFirestore());
  }

  Future<void> updateAnnouncement(Announcement announcement) async {
    await _firestore
        .collection('announcements')
        .doc(announcement.id)
        .update(announcement.toMap());
  }

  Future<void> deleteRubrique(String id) async {
    await _firestore.collection('rubriques').doc(id).delete();
  }

  Future<void> deleteAnnouncement(String id) async {
    await _firestore.collection('announcements').doc(id).delete();
  }
}
