import 'package:flutter/foundation.dart';
import '../models/rubrique.dart';
import '../models/announcement.dart';
import '../services/firestore_service.dart';

class ContentProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Rubrique> _rubriques = [];
  List<Announcement> _announcements = [];

  List<Rubrique> get rubriques => _rubriques;
  List<Announcement> get announcements => _announcements;

  Future<void> fetchRubriques() async {
    _rubriques = await _firestoreService.getRubriques();
    notifyListeners();
  }

  Future<void> fetchAnnouncements() async {
    _announcements = await _firestoreService.getAnnouncements();
    notifyListeners();
  }

  Future<void> addRubrique(Rubrique rubrique) async {
    await _firestoreService.addRubrique(rubrique);
    await fetchRubriques();
  }

  Future<void> addAnnouncement(Announcement announcement) async {
    await _firestoreService.addAnnouncement(announcement);
    await fetchAnnouncements();
  }

  Future<void> updateRubrique(Rubrique rubrique) async {
    await _firestoreService.updateRubrique(rubrique);
    await fetchRubriques();
  }

  Future<void> updateAnnouncement(Announcement announcement) async {
    await _firestoreService.updateAnnouncement(announcement);
    await fetchAnnouncements();
  }

  Future<void> deleteRubrique(String id) async {
    await _firestoreService.deleteRubrique(id);
    await fetchRubriques();
  }

  Future<void> deleteAnnouncement(String id) async {
    await _firestoreService.deleteAnnouncement(id);
    await fetchAnnouncements();
  }
}
