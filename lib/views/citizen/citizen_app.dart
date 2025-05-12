import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import 'rubrique_list.dart';
import 'announcement_feed.dart';
import '../../services/firebase_service.dart';
import 'rubrique_detail.dart';

class CitizenApp extends StatefulWidget {
  @override
  State<CitizenApp> createState() => _CitizenAppState();
}

class _CitizenAppState extends State<CitizenApp> {
  String _lang = 'ar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Sfax Baladyti',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
            ),
            actions: [
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _lang,
                  dropdownColor: Theme.of(context).colorScheme.primary,
                  icon: Icon(Icons.language, color: Colors.white),
                  items: [
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text('العربية',
                          style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: 'fr',
                      child: Text('Français',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _lang = val!;
                    });
                  },
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    context,
                    _lang == 'ar'
                        ? 'معلومات البلدية'
                        : 'Informations Municipales',
                    Icons.info_outline,
                  ),
                  SizedBox(height: 16),
                  _HorizontalRubriqueList(lang: _lang),
                  SizedBox(height: 32),
                  _buildSectionHeader(
                    context,
                    _lang == 'ar' ? 'آخر الإعلانات' : 'Dernières Annonces',
                    Icons.announcement,
                  ),
                  SizedBox(height: 16),
                  AnnouncementFeed(lang: _lang),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    final bool isArabic =
        title.isNotEmpty && RegExp(r'^[\u0600-\u06FF]').hasMatch(title);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.teal.withOpacity(0.2),
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isArabic) ...[
            Icon(
              icon,
              color: Colors.teal,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
            ),
          ] else ...[
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
            ),
            SizedBox(width: 8),
            Icon(
              icon,
              color: Colors.teal,
            ),
          ]
        ],
      ),
    );
  }
}

class _HorizontalRubriqueList extends StatelessWidget {
  final String lang;
  const _HorizontalRubriqueList({required this.lang});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService().getRubriques(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('خطأ في تحميل الأقسام'));
        }
        final allRubriques = snapshot.data as List<dynamic>? ?? [];
        final rubriques =
            allRubriques.where((r) => r.parentId == null).toList();
        if (rubriques.isEmpty) {
          return Center(child: Text('لا توجد أقسام متاحة'));
        }
        return Container(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: rubriques.length,
            separatorBuilder: (context, i) => SizedBox(width: 16),
            itemBuilder: (context, index) {
              final rubrique = rubriques[index];
              final String title = rubrique.title[lang] ?? '';
              final String description = rubrique.description[lang] ?? '';
              final bool isArabic = lang == 'ar';
              final Map<String, IconData> iconMap = const {
                'folder': Icons.folder,
                'home': Icons.home,
                'info': Icons.info,
                'event': Icons.event,
                'school': Icons.school,
                'work': Icons.work,
                'local_hospital': Icons.local_hospital,
                'local_police': Icons.local_police,
                'local_fire_department': Icons.local_fire_department,
                'local_library': Icons.local_library,
                'local_post_office': Icons.local_post_office,
                'local_pharmacy': Icons.local_pharmacy,
                'local_grocery_store': Icons.local_grocery_store,
                'local_cafe': Icons.local_cafe,
                'local_bar': Icons.local_bar,
                'local_parking': Icons.local_parking,
                'local_taxi': Icons.local_taxi,
                'local_airport': Icons.local_airport,
                'local_atm': Icons.local_atm,
                'local_activity': Icons.local_activity,
              };
              final IconData iconData = iconMap[rubrique.icon] ?? Icons.folder;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RubriqueDetail(rubrique: rubrique, lang: lang),
                    ),
                  );
                },
                child: Container(
                  width: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.teal.withOpacity(0.18),
                        Colors.amber.withOpacity(0.10),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.10),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE8F5E9),
                        ),
                        child: Icon(
                          iconData,
                          color: Colors.blue[700],
                          size: 32,
                        ),
                      ),
                      SizedBox(height: 16),
                      Flexible(
                        child: Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[800],
                                    fontFamily: isArabic ? 'Cairo' : null,
                                  ),
                          textAlign:
                              isArabic ? TextAlign.right : TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            description,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.teal[900],
                                      fontFamily: isArabic ? 'Cairo' : null,
                                    ),
                            textAlign:
                                isArabic ? TextAlign.right : TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
