import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/rubrique.dart';

class RubriqueEditor extends StatefulWidget {
  final Rubrique? rubrique;
  RubriqueEditor({Key? key, this.rubrique}) : super(key: key);
  @override
  _RubriqueEditorState createState() => _RubriqueEditorState();
}

class _RubriqueEditorState extends State<RubriqueEditor> {
  final _formKey = GlobalKey<FormState>();
  final _firebaseService = FirebaseService();
  String _title = '';
  String _description = '';
  String _icon = 'folder';
  String? _parentId;
  bool _initialized = false;
  bool _isCreatingWithChildren = false;
  List<Rubrique> _allRubriques = [];
  List<Map<String, dynamic>> _childRubriques = [];
  bool _creationTypeDialogShown = false;

  final Map<String, IconData> _iconMap = {
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
  void initState() {
    super.initState();
    _fetchRubriques();
  }

  void _fetchRubriques() async {
    final rubriques = await _firebaseService.getRubriques().first;
    setState(() {
      _allRubriques = rubriques;
    });
  }

  void _initFields() {
    if (!_initialized && widget.rubrique != null) {
      _title = widget.rubrique!.title['ar'] ?? '';
      _description = widget.rubrique!.description['ar'] ?? '';
      _icon = widget.rubrique!.icon;
      _parentId = widget.rubrique!.parentId;
      _initialized = true;
    }
  }

  void _showCreationTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('نوع القسم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('قسم واحد'),
              onTap: () {
                setState(() {
                  _isCreatingWithChildren = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.folder_special),
              title: Text('قسم مع أقسام فرعية'),
              onTap: () {
                setState(() {
                  _isCreatingWithChildren = true;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showIconPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choisir une icône'),
        content: Container(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _iconMap.length,
            itemBuilder: (context, index) {
              String iconName = _iconMap.keys.elementAt(index);
              return InkWell(
                onTap: () {
                  setState(() => _icon = iconName);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _icon == iconName
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _iconMap[iconName],
                    color: _icon == iconName
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAddChildDialog() async {
    String childTitle = '';
    String childDescription = '';
    String childIcon = 'folder';
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text('إضافة قسم فرعي'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'العنوان'),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                  onChanged: (v) => childTitle = v,
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(labelText: 'الوصف'),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                  onChanged: (v) => childDescription = v,
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final selectedIcon = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('اختر أيقونة'),
                        content: Container(
                          width: double.maxFinite,
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _iconMap.length,
                            itemBuilder: (context, index) {
                              String iconName = _iconMap.keys.elementAt(index);
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context, iconName);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: childIcon == iconName
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _iconMap[iconName],
                                    color: childIcon == iconName
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                    if (selectedIcon != null) {
                      setStateDialog(() {
                        childIcon = selectedIcon;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(_iconMap[childIcon]),
                        SizedBox(width: 8),
                        Text('اختر أيقونة'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    _childRubriques.add({
                      'title': childTitle,
                      'description': childDescription,
                      'icon': childIcon,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initFields();
    if (widget.rubrique == null && !_creationTypeDialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCreationTypeDialog();
      });
      _creationTypeDialogShown = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rubrique == null ? 'إضافة قسم' : 'تعديل قسم'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'القسم الرئيسي',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    labelText: 'العنوان',
                    border: OutlineInputBorder(),
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال العنوان';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                SizedBox(height: 10),
                if (!_isCreatingWithChildren)
                  TextFormField(
                    initialValue: _description,
                    decoration: InputDecoration(
                      labelText: 'الوصف',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (!_isCreatingWithChildren &&
                          (value == null || value.isEmpty)) {
                        return 'يرجى إدخال الوصف';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value!;
                    },
                  ),
                SizedBox(height: 10),
                InkWell(
                  onTap: _showIconPicker,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(_iconMap[_icon]),
                        SizedBox(width: 8),
                        Text('اختر أيقونة'),
                      ],
                    ),
                  ),
                ),
                if (_isCreatingWithChildren) ...[
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الأقسام الفرعية',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showAddChildDialog,
                        icon: Icon(Icons.add),
                        label: Text('إضافة قسم فرعي'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0074B7),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ..._childRubriques.map((child) => Card(
                        child: ListTile(
                          leading: Icon(_iconMap[child['icon']]),
                          title: Text(child['title']),
                          subtitle: Text(child['description']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _childRubriques.remove(child);
                              });
                            },
                          ),
                        ),
                      )),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      if (widget.rubrique == null) {
                        // Create parent rubrique and get Firestore ID
                        final parent = Rubrique(
                          id: '', // temp, will be replaced
                          title: {'ar': _title},
                          description: {'ar': _description},
                          icon: _icon,
                        );

                        final parentId =
                            await _firebaseService.addRubrique(parent);

                        // If creating with children, add all child rubriques with correct parentId
                        if (_isCreatingWithChildren) {
                          for (var child in _childRubriques) {
                            final childRubrique = Rubrique(
                              id: '', // Firestore will assign
                              title: {'ar': child['title']},
                              description: {'ar': child['description']},
                              icon: child['icon'],
                              parentId: parentId,
                            );
                            await _firebaseService.addRubrique(childRubrique);
                          }
                        }
                      } else {
                        // Update existing rubrique
                        final updated = Rubrique(
                          id: widget.rubrique!.id,
                          title: {'ar': _title},
                          description: {'ar': _description},
                          icon: _icon,
                          parentId: _parentId,
                        );
                        await _firebaseService.updateRubrique(
                            updated.id, updated);
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: Text('حفظ'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
