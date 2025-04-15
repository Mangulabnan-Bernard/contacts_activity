import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';
import 'members.dart';
import 'variables.dart';
import 'contact.dart';
import 'members.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('database');
  runApp(CupertinoApp(
    theme: CupertinoThemeData(brightness: Brightness.dark),
    debugShowCheckedModeBanner: false,
    home: Homepage(),
  ));
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var box = Hive.box('database');
  List<dynamic> contacts = [];
  List<dynamic> filteredContacts = [];
  String? selectedImagePath;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _searchController.addListener(_filterContacts);
  }

  void _loadContacts() {
    if (box.get('contacts') == null) {
      setState(() {
        contacts = [];
        filteredContacts = [];
      });
    } else {
      setState(() {
        contacts = box.get('contacts');
        filteredContacts = contacts;
      });
    }
  }

  void _filterContacts() {
    List<dynamic> results = [];
    if (_searchController.text.isEmpty) {
      results = contacts;
    } else {
      results = contacts.where((contact) {
        final name = contact['name'].toString().toLowerCase();
        final phone = contact['phone'].toString().toLowerCase();
        final query = _searchController.text.toLowerCase();
        return name.contains(query) || phone.contains(query);
      }).toList();
    }
    setState(() {
      filteredContacts = results;
    });
  }

  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  List<TextEditingController> _phoneControllers = [TextEditingController()];
  List<TextEditingController> _emailControllers = [TextEditingController()];
  List<TextEditingController> _urlControllers = [TextEditingController()];

  Future<void> _pickImage() async {
    final params = OpenFileDialogParams(
      dialogType: OpenFileDialogType.image,
    );
    final filePath = await FlutterFileDialog.pickFile(params: params);
    if (filePath != null) {
      setState(() {
        selectedImagePath = filePath;
      });
    }
  }

  void _showDeleteConfirmationDialog(int index) {
    if (index < 0 || index >= filteredContacts.length) {
      print('Invalid index in _showDeleteConfirmationDialog: $index');
      return;
    }
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Delete Contact'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  contacts.removeAt(index);
                  box.put('contacts', contacts);
                  _filterContacts();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          child: Icon(CupertinoIcons.add),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return CupertinoActionSheet(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text('New Contact'),
                          CupertinoButton(
                            child: Text('Done'),
                            onPressed: () {
                              if (_phoneControllers.first.text.isEmpty) {
                                _showErrorDialog('Phone number cannot be empty.');
                                return;
                              }

                              setState(() {
                                contacts.add({
                                  "name": _fname.text + " " + _lname.text,
                                  "phone": _phoneControllers.map((controller) => controller.text).toList(),
                                  "email": _emailControllers.map((controller) => controller.text).toList(),
                                  "url": _urlControllers.map((controller) => controller.text).toList(),
                                  "photo": selectedImagePath ?? "",
                                });
                                box.put('contacts', contacts);
                                _filterContacts();
                              });
                              _fname.clear();
                              _lname.clear();
                              _phoneControllers = [TextEditingController()];
                              _emailControllers = [TextEditingController()];
                              _urlControllers = [TextEditingController()];
                              selectedImagePath = null;
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      message: Column(
                        children: [
                          selectedImagePath != null
                              ? ClipOval(
                            child: Image.file(
                              File(selectedImagePath!),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Icon(
                            CupertinoIcons.person_circle_fill,
                            color: CupertinoColors.white,
                            size: 200,
                          ),
                          CupertinoButton(
                            child: Text('Add Photo'),
                            onPressed: () async {
                              await _pickImage();
                              setState(() {});
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey.withOpacity(0.1),
                            ),
                            child: Column(
                              children: [
                                CupertinoTextField(
                                  controller: _fname,
                                  placeholder: 'First Name',
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey.withOpacity(0.0),
                                  ),
                                ),
                                Divider(
                                  color: CupertinoColors.systemGrey.withOpacity(0.2),
                                ),
                                CupertinoTextField(
                                  controller: _lname,
                                  placeholder: 'Last Name',
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey.withOpacity(0.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          ..._phoneControllers.asMap().entries.map((entry) {
                            int idx = entry.key;
                            TextEditingController controller = entry.value;
                            String label = _getPhoneLabel(idx);
                            return Column(
                              children: [
                                CupertinoTextField(
                                  prefix: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (idx == 0)
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          child: Icon(
                                            CupertinoIcons.add_circled_solid,
                                            color: CupertinoColors.systemGreen,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _phoneControllers.insert(0, TextEditingController());
                                            });
                                          },
                                        ),
                                      Text(label),
                                    ],
                                  ),
                                  controller: controller,
                                  placeholder: 'Phone Number',
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey.withOpacity(0.1),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                          SizedBox(height: 20),
                          ..._emailControllers.asMap().entries.map((entry) {
                            int idx = entry.key;
                            TextEditingController controller = entry.value;
                            return Column(
                              children: [
                                CupertinoTextField(
                                  prefix: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (idx == 0)
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          child: Icon(
                                            CupertinoIcons.add_circled_solid,
                                            color: CupertinoColors.systemGreen,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _emailControllers.insert(0, TextEditingController());
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                  controller: controller,
                                  placeholder: 'Email',
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey.withOpacity(0.1),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                          SizedBox(height: 20),
                          ..._urlControllers.asMap().entries.map((entry) {
                            int idx = entry.key;
                            TextEditingController controller = entry.value;
                            return Column(
                              children: [
                                CupertinoTextField(
                                  prefix: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (idx == 0)
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          child: Icon(
                                            CupertinoIcons.add_circled_solid,
                                            color: CupertinoColors.systemGreen,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _urlControllers.insert(0, TextEditingController());
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                  controller: controller,
                                  placeholder: 'URL',
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey.withOpacity(0.1),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                          SizedBox(height: double.maxFinite),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Contacts',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ],
              ),
              SizedBox(height: 15),
              CupertinoTextField(
                controller: _searchController,
                placeholder: 'Search',
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                prefix: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    CupertinoIcons.search,
                    color: CupertinoColors.systemGrey2,
                    size: 21,
                  ),
                ),
                suffix: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    CupertinoIcons.mic_fill,
                    color: CupertinoColors.systemGrey2,
                    size: 21,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(color: CupertinoColors.systemGrey.withOpacity(0.3)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => AboutPage()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        ' G',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bernard C. Mangulabnan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'My Card',
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(color: CupertinoColors.systemGrey.withOpacity(0.3)),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, int index) {
                    if (index < 0 || index >= filteredContacts.length) {
                      print('Invalid index in ListView.builder: $index');
                      return Container();
                    }
                    return Dismissible(
                      key: Key(filteredContacts[index]['name']),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        color: CupertinoColors.systemRed,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(
                          CupertinoIcons.delete,
                          color: CupertinoColors.white,
                        ),
                      ),
                      secondaryBackground: Container(
                        color: CupertinoColors.systemRed,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(
                          CupertinoIcons.delete,
                          color: CupertinoColors.white,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        _showDeleteConfirmationDialog(index);
                        return false;
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (index < 0 || index >= filteredContacts.length) {
                            print('Invalid index in onTap: $index');
                            return;
                          }
                          setState(() {
                            name = filteredContacts[index]['name'];
                            phone = filteredContacts[index]['phone'];
                            email = filteredContacts[index]['email'];
                            url = filteredContacts[index]['url'];
                            photo = filteredContacts[index]['photo'];
                          });
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => Contact()),
                          );
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 35),
                                child: SizedBox(width: 10),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(filteredContacts[index]['name'] == " "
                                        ? filteredContacts[index]['phone'][0]
                                        : filteredContacts[index]['name'],
                                style: TextStyle(fontSize: 13),
                              ),

                                    Divider(
                                      color: CupertinoColors.systemGrey.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  String _getPhoneLabel(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Work';
      case 2:
        return 'School';
      case 3:
        return 'Other 1';
      case 4:
        return 'Other 2';
      default:
        return 'Other ${index - 2}';
    }
  }
}
