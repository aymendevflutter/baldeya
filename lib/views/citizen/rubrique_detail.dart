import 'package:flutter/material.dart';
import '../../models/rubrique.dart';
import '../../services/firebase_service.dart';

class RubriqueDetail extends StatelessWidget {
  final Rubrique rubrique;
  final String lang;
  const RubriqueDetail({Key? key, required this.rubrique, required this.lang})
      : super(key: key);

  static const Map<String, IconData> iconMap = {
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
    final IconData iconData = iconMap[rubrique.icon] ?? Icons.folder;
    final String title = rubrique.title[lang] ?? '';
    final String description = rubrique.description[lang] ?? '';
    final String content = rubrique.content[lang] ?? '';
    final bool isArabic = lang == 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: isArabic ? 'Cairo' : null,
            fontWeight: FontWeight.bold,
          ),
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
        ),
        backgroundColor: Color(0xFF4FC3F7), // Soft blue
        flexibleSpace: null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      iconData,
                      size: 40,
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
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: isArabic ? 'Cairo' : null,
                              ),
                          textDirection:
                              isArabic ? TextDirection.rtl : TextDirection.ltr,
                          textAlign:
                              isArabic ? TextAlign.right : TextAlign.left,
                        ),
                        if (description.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Text(
                            description,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.grey[600],
                                      fontFamily: isArabic ? 'Cairo' : null,
                                    ),
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            textAlign:
                                isArabic ? TextAlign.right : TextAlign.left,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Show children if they exist
            StreamBuilder(
              stream: FirebaseService().getRubriques(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('خطأ في تحميل الأقسام الفرعية'));
                }
                final allRubriques = snapshot.data as List<dynamic>? ?? [];
                final children = allRubriques
                    .where((r) => r.parentId == rubrique.id)
                    .toList();

                if (children.isEmpty) {
                  if (content.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'المحتوى' : 'Contenu',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: isArabic ? 'Cairo' : null,
                                  ),
                          textDirection:
                              isArabic ? TextDirection.rtl : TextDirection.ltr,
                          textAlign:
                              isArabic ? TextAlign.right : TextAlign.left,
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            content,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontFamily: isArabic ? 'Cairo' : null,
                                      height: 1.5,
                                    ),
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            textAlign:
                                isArabic ? TextAlign.right : TextAlign.left,
                          ),
                        ),
                      ],
                    );
                  }
                  return Center(child: Text('لا توجد أقسام فرعية'));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'الأقسام الفرعية' : 'Sous-rubriques',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: isArabic ? 'Cairo' : null,
                          ),
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    ),
                    SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: children.length,
                      itemBuilder: (context, index) {
                        final child = children[index];
                        final childTitle = child.title[lang] ?? '';
                        final childIcon = iconMap[child.icon] ?? Icons.folder;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RubriqueDetail(
                                  rubrique: child,
                                  lang: lang,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                  Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  childIcon,
                                  size: 32,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  childTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: isArabic ? 'Cairo' : null,
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
