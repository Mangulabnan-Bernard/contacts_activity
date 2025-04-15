import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'members.dart';
import 'variables.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'members.dart'; // Ensure this import is correct

class MyCard extends StatefulWidget {
  const MyCard({super.key});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  late List<TextEditingController> _phoneControllers;
  late List<TextEditingController> _emailControllers;
  late List<TextEditingController> _urlControllers;

  @override
  void initState() {
    super.initState();
    _phoneControllers = List.generate(myCardPhone.length, (index) => TextEditingController(text: myCardPhone[index]));
    _emailControllers = List.generate(myCardEmail.length, (index) => TextEditingController(text: myCardEmail[index]));
    _urlControllers = List.generate(myCardUrl.length, (index) => TextEditingController(text: myCardUrl[index]));
  }

  void _saveChanges() {
    setState(() {
      myCardPhone = _phoneControllers.map((controller) => controller.text).toList();
      myCardEmail = _emailControllers.map((controller) => controller.text).toList();
      myCardUrl = _urlControllers.map((controller) => controller.text).toList();
    });
    var box = Hive.box('database');
    box.put('myCardPhone', myCardPhone);
    box.put('myCardEmail', myCardEmail);
    box.put('myCardUrl', myCardUrl);
    box.put('myCardPhoto', myCardPhoto);
  }

  Future<void> _replaceImage() async {
    final params = OpenFileDialogParams(
      dialogType: OpenFileDialogType.image,
    );
    final filePath = await FlutterFileDialog.pickFile(params: params);
    if (filePath != null) {
      setState(() {
        myCardPhoto = filePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  myCardPhoto.isNotEmpty
                      ? Image.file(
                    File(myCardPhoto),
                    width: double.infinity,
                    fit: BoxFit.fill,
                    height: 300,
                  )
                      : Icon(
                    CupertinoIcons.person_circle_fill,
                    color: CupertinoColors.white,
                    size: 300,
                  ),
                  Positioned(
                    top: -2,
                    left: -15,
                    child: Row(
                      children: [
                        CupertinoButton(
                          child: Icon(
                            CupertinoIcons.chevron_back,
                            color: CupertinoColors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "last used: ",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: CupertinoColors.white,
                              ),
                              child: Text(
                                "P",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: CupertinoColors.black,
                                ),
                              ),
                            ),
                            Text(
                              " Primary",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_forward,
                              size: 12,
                              color: CupertinoColors.white,
                            )
                          ],
                        ),
                        Text(
                          myCardName,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_phoneControllers.isNotEmpty)
                                _buildActionButton(
                                  CupertinoIcons.bubble_middle_bottom_fill,
                                  'Message',
                                  'sms:${_phoneControllers.first.text}',
                                ),
                              if (_phoneControllers.isNotEmpty)
                                _buildActionButton(
                                  CupertinoIcons.phone_solid,
                                  'Call',
                                  'tel:${_phoneControllers.first.text}',
                                ),
                              if (_phoneControllers.isNotEmpty)
                                _buildActionButton(
                                  CupertinoIcons.video_camera_solid,
                                  'Video',
                                  'sms:${_phoneControllers.first.text}',
                                ),
                              if (_emailControllers.isNotEmpty)
                                _buildActionButton(
                                  CupertinoIcons.mail_solid,
                                  'Mail',
                                  'mailto:${_emailControllers.first.text}',
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    if (_phoneControllers.isNotEmpty)
                      _buildEditableInfoTile('Home', 'tel:${_phoneControllers.first.text}', _phoneControllers.first),
                    ..._phoneControllers.skip(1).map((controller) {
                      if (controller.text.isNotEmpty) {
                        return _buildEditableInfoTile(_getPhoneLabel(_phoneControllers.indexOf(controller)), 'tel:${controller.text}', controller);
                      }
                      return SizedBox.shrink();
                    }).toList(),
                    SizedBox(height: 10),
                    if (_emailControllers.isNotEmpty)
                      _buildEditableInfoTile('Email', 'mailto:${_emailControllers.first.text}', _emailControllers.first),
                    ..._emailControllers.skip(1).map((controller) {
                      if (controller.text.isNotEmpty) {
                        return _buildEditableInfoTile('Email', 'mailto:${controller.text}', controller);
                      }
                      return SizedBox.shrink();
                    }).toList(),
                    SizedBox(height: 10),
                    if (_urlControllers.isNotEmpty)
                      _buildEditableInfoTile('URL', _urlControllers.first.text, _urlControllers.first),
                    ..._urlControllers.skip(1).map((controller) {
                      if (controller.text.isNotEmpty) {
                        return _buildEditableInfoTile('URL', controller.text, controller);
                      }
                      return SizedBox.shrink();
                    }).toList(),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => AboutPage()),
                  );
                },
                child: Container(

                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.systemBlue,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, String uriScheme) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          CupertinoButton(
            child: Icon(icon, color: CupertinoColors.white),
            onPressed: () async {
              final Uri uri = Uri.parse(uriScheme);
              await launchUrl(uri);
            },
          ),
          Text(
            label,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }

  Widget _buildEditableInfoTile(String label, String uriScheme, TextEditingController controller) {
    return GestureDetector(
      onLongPress: () {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Edit $label'),
              content: CupertinoTextField(
                controller: controller,
                placeholder: label,
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Save'),
                  onPressed: () {
                    _saveChanges();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      onTap: () async {
        if (uriScheme.isNotEmpty) {
          final Uri uri = Uri.parse(uriScheme);
          await launchUrl(uri);
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: CupertinoColors.systemGrey.withOpacity(0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 13),
            ),
            Text(
              controller.text,
              style: TextStyle(
                color: CupertinoColors.systemBlue,
                fontSize: 14,
              ),
            )
          ],
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
