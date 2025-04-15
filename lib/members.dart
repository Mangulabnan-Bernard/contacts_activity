import 'package:flutter/cupertino.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final List<Map<String, dynamic>> members = [
    {"name": "Ives Lopez", "role": "Lead Developer", "icon": CupertinoIcons.star, "color": CupertinoColors.systemBlue},
    {"name": "Bernard Mangulabnan", "role": "Lead Developer/Designer", "icon": CupertinoIcons.paintbrush, "color": CupertinoColors.systemGreen},
    {"name": "Ivan Lopez", "role": "Co Developer/Ui Designer", "icon": CupertinoIcons.star, "color": CupertinoColors.systemBlue},
    {"name": "Mervin Magat", "role": "Backend Developer", "icon": CupertinoIcons.gear, "color": CupertinoColors.systemOrange},
    {"name": "Paul Vismonte", "role": "Tester/Testing", "icon": CupertinoIcons.checkmark_seal, "color": CupertinoColors.systemPurple},
    {"name": "Renz Samson", "role": "Content Writer/Accessibility Tester", "icon": CupertinoIcons.doc_text, "color": CupertinoColors.systemRed},
    {"name": "Steven Lising", "role": "Content Writer/Tester", "icon": CupertinoIcons.archivebox_fill, "color": CupertinoColors.systemPink},
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('We are the Developers'),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Meet the Team',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return CupertinoListTile(
                      leading: Icon(
                        member['icon'],
                        color: member['color'],
                      ),
                      title: Text(member['name']),
                      subtitle: Text(member['role']),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
