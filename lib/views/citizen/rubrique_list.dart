import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/rubrique.dart';
import 'rubrique_detail.dart';

class RubriqueList extends StatelessWidget {
  final String lang;
  const RubriqueList({Key? key, required this.lang}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Rubrique>>(
      stream: FirebaseService().getRubriques(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                SizedBox(height: 16),
                Text(
                  'خطأ في تحميل الأقسام',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          );
        }

        final allRubriques = snapshot.data ?? [];
        final rubriques =
            allRubriques.where((r) => r.parentId == null).toList();

        if (rubriques.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'لا توجد أقسام متاحة',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          );
        }

        return _buildRubriqueList(context, rubriques, allRubriques, lang);
      },
    );
  }

  Widget _buildRubriqueList(BuildContext context, List<Rubrique> rubriques,
      List<Rubrique> allRubriques, String lang) {
    final iconMap = this.iconMap;
    return ListView.builder(
      itemCount: rubriques.length,
      itemBuilder: (context, index) {
        final rubrique = rubriques[index];
        final IconData iconData = iconMap[rubrique.icon] ?? Icons.folder;
        final String title = rubrique.title[lang] ?? '';
        final String description = rubrique.description[lang] ?? '';
        final bool isArabic = lang == 'ar';
        final children =
            allRubriques.where((r) => r.parentId == rubrique.id).toList();
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: () {
              if (children.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: Text(title)),
                      body: _buildRubriqueList(
                          context, children, allRubriques, lang),
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RubriqueDetail(rubrique: rubrique, lang: lang),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        iconData,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: isArabic ? 'Cairo' : null,
                                ),
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            textAlign:
                                isArabic ? TextAlign.right : TextAlign.left,
                          ),
                          SizedBox(height: 4),
                          Text(
                            description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  fontFamily: isArabic ? 'Cairo' : null,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            textAlign:
                                isArabic ? TextAlign.right : TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      children.isNotEmpty
                          ? Icons.chevron_right
                          : Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
