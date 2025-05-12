import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/announcement.dart';

class AnnouncementEditor extends StatefulWidget {
  final Announcement? announcement;
  AnnouncementEditor({Key? key, this.announcement}) : super(key: key);
  @override
  _AnnouncementEditorState createState() => _AnnouncementEditorState();
}

class _AnnouncementEditorState extends State<AnnouncementEditor> {
  final _formKey = GlobalKey<FormState>();
  final _firebaseService = FirebaseService();
  String _title = '';
  String _content = '';
  String _imageUrl = '';
  bool _isUrgent = false;
  bool _initialized = false;

  void _initFields() {
    if (!_initialized && widget.announcement != null) {
      _title = widget.announcement!.title['ar'] ?? '';
      _content = widget.announcement!.content['ar'] ?? '';
      _imageUrl = widget.announcement!.imageUrl ?? '';
      _isUrgent = widget.announcement!.isUrgent;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initFields();
    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.announcement == null ? 'إضافة إعلان' : 'تعديل إعلان')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('العربية',
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
                TextFormField(
                  initialValue: _content,
                  decoration: InputDecoration(
                    labelText: 'المحتوى',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال المحتوى';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _content = value!;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _imageUrl,
                  decoration: InputDecoration(
                    labelText: 'رابط الصورة (اختياري)',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _imageUrl = value ?? '';
                  },
                ),
                SizedBox(height: 10),
                SwitchListTile(
                  title: Text('عاجل'),
                  value: _isUrgent,
                  onChanged: (value) {
                    setState(() {
                      _isUrgent = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (widget.announcement == null) {
                        final announcement = Announcement(
                          id: DateTime.now().toString(),
                          title: {'ar': _title},
                          content: {'ar': _content},
                          imageUrl: _imageUrl.isEmpty ? null : _imageUrl,
                          date: DateTime.now(),
                          isUrgent: _isUrgent,
                        );
                        await _firebaseService.addAnnouncement(announcement);
                      } else {
                        final updated = Announcement(
                          id: widget.announcement!.id,
                          title: {'ar': _title},
                          content: {'ar': _content},
                          imageUrl: _imageUrl.isEmpty ? null : _imageUrl,
                          date: widget.announcement!.date,
                          isUrgent: _isUrgent,
                        );
                        await _firebaseService.updateAnnouncement(
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
