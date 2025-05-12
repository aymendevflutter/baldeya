import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/announcement.dart';
import 'announcement_editor.dart';

class AnnouncementListPage extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Liste des Annonces',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Color(0xFF0074B7),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Announcement>>(
                stream: _firebaseService.getAnnouncements(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur de chargement'));
                  }
                  final announcements = snapshot.data ?? [];
                  if (announcements.isEmpty) {
                    return Center(child: Text('Aucune annonce trouvée.'));
                  }
                  return ListView.separated(
                    itemCount: announcements.length,
                    separatorBuilder: (context, i) => Divider(),
                    itemBuilder: (context, index) {
                      final ann = announcements[index];
                      return ListTile(
                        leading:
                            Icon(Icons.announcement, color: Color(0xFF0074B7)),
                        title: Text(ann.title['ar'] ?? ''),
                        subtitle: Text(
                          ann.content['ar'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.amber[800]),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AnnouncementEditor(
                                      announcement: ann,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _firebaseService
                                    .deleteAnnouncement(ann.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Nouvelle Annonce'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0074B7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AnnouncementEditor()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
