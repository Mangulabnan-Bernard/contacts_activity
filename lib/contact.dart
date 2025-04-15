import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'variables.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  late List<TextEditingController> _phoneControllers;
  late List<TextEditingController> _emailControllers;
  late List<TextEditingController> _smsControllers;
  late List<TextEditingController> _urlControllers;

  @override
  void initState() {
    super.initState();
    _phoneControllers = List.generate(phone.length, (index) => TextEditingController(text: phone[index]));
    _emailControllers = List.generate(email.length, (index) => TextEditingController(text: email[index]));
    _smsControllers = List.generate(phone.length, (index) => TextEditingController(text: phone[index]));
    _urlControllers = List.generate(url.length, (index) => TextEditingController(text: url[index]));
  }

  void _saveChanges() {
    var box = Hive.box('database');
    var contacts = box.get('contacts');
    for (var contact in contacts) {
      if (contact['name'] == name) {
        contact['phone'] = _phoneControllers.map((controller) => controller.text).toList();
        contact['email'] = _emailControllers.map((controller) => controller.text).toList();
        contact['url'] = _urlControllers.map((controller) => controller.text).toList();
        break;
      }
    }
    box.put('contacts', contacts);
    setState(() {});
  }

  Future<void> _replaceImage() async {
    final params = OpenFileDialogParams(
      dialogType: OpenFileDialogType.image,
    );
    final filePath = await FlutterFileDialog.pickFile(params: params);
    if (filePath != null) {
      setState(() {
        photo = filePath;
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
                  photo.isNotEmpty
                      ? Image.file(
                    File(photo),
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
                        CupertinoButton(
                          child: Icon(
                            CupertinoIcons.photo_camera_solid,
                            color: CupertinoColors.white,
                          ),
                          onPressed: _replaceImage,
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
                          name,
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
                    if (_smsControllers.isNotEmpty)
                      _buildEditableInfoTile('SMS', 'sms:${_smsControllers.first.text}', _smsControllers.first),
                    ..._smsControllers.skip(1).map((controller) {
                      if (controller.text.isNotEmpty) {
                        return _buildEditableInfoTile('SMS', 'sms:${controller.text}', controller);
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
