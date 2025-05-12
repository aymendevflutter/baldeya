import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/rubrique.dart';
import 'rubrique_editor.dart';

class RubriqueListPage extends StatelessWidget {
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
              'Liste des Rubriques',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Color(0xFF0074B7),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Rubrique>>(
                stream: _firebaseService.getRubriques(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur de chargement'));
                  }
                  final rubriques = snapshot.data ?? [];
                  if (rubriques.isEmpty) {
                    return Center(child: Text('Aucune rubrique trouvée.'));
                  }
                  return ListView.separated(
                    itemCount: rubriques.length,
                    separatorBuilder: (context, i) => Divider(),
                    itemBuilder: (context, index) {
                      final rubrique = rubriques[index];
                      return ListTile(
                        leading: Icon(Icons.category, color: Color(0xFF0074B7)),
                        title: Text(rubrique.title['ar'] ?? ''),
                        subtitle: Text(
                          rubrique.description['ar'] ?? '',
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
                                    builder: (_) => RubriqueEditor(
                                      rubrique: rubrique,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _firebaseService
                                    .deleteRubrique(rubrique.id);
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
                label: Text('Nouvelle Rubrique'),
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
                    MaterialPageRoute(builder: (_) => RubriqueEditor()),
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
