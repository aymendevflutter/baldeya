import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app_state.dart';
import 'dashboard_page.dart';
import 'login_page.dart';
import 'announcement_editor.dart';
import 'rubrique_editor.dart';
import 'announcement_list_page.dart';
import 'rubrique_list_page.dart';

class AdminApp extends StatefulWidget {
  @override
  _AdminAppState createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xFFF5F6FA),
            body: Row(
              children: [
                _buildSidebar(context),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 64,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                'Panneau d\'Administration',
                                style: TextStyle(
                                  color: Color(0xFF0074B7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            IconButton(
                              icon:
                                  Icon(Icons.logout, color: Color(0xFF0074B7)),
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Provider.of<AppState>(context, listen: false)
                                    .toggleView();
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _getSelectedPage(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return LoginPage();
        }
      },
    );
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return DashboardPage();
      case 1:
        return AnnouncementListPage();
      case 2:
        return RubriqueListPage();
   //   case 3:
    //    return Center(child: Text('Page Utilisateurs en construction'));
    //  case 4:
    //    return Center(child: Text('Page Paramètres en construction'));
      default:
        return DashboardPage();
    }
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Color(0xFF0074B7).withOpacity(0.08),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 12),
                Text(
                  'Sfax Baladyti',
                  style: TextStyle(
                    color: Color(0xFF0074B7),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          _buildNavItem(
            context,
            'Tableau de bord',
            Icons.dashboard,
            0,
          ),
          _buildNavItem(
            context,
            'Annonces',
            Icons.announcement,
            1,
          ),
          _buildNavItem(
            context,
            'Rubriques',
            Icons.category,
            2,
          ),
          /*
          _buildNavItem(
            context,
            'Utilisateurs',
            Icons.people,
            3,
          ),
          _buildNavItem(
            context,
            'Paramètres',
            Icons.settings,
            4,
          ),
          */
          Spacer(),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF0074B7),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Administrateur',
                      style: TextStyle(
                        color: Color(0xFF0074B7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'admin@sfax.baladyti.tn',
                      style: TextStyle(
                        color: Color(0xFF0074B7).withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String title,
    IconData icon,
    int index,
  ) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isSelected
            ? Color(0xFF0074B7).withOpacity(0.08)
            : Colors.transparent,
        child: Row(
          children: [
            Icon(
              icon,
              color: Color(0xFF0074B7),
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF0074B7),
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
