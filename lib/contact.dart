import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'variables.dart';
import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(

        child: SafeArea(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [

            Image.network(photo, width: double.infinity, fit: BoxFit.fill, height: 300,),

            Positioned(
                top: -2,
                left: -15,
                child: Row(
              children: [
                CupertinoButton(child: Icon(CupertinoIcons.chevron_back, color: CupertinoColors.white,), onPressed: (){
                  Navigator.pop(context);
                })
              ],
            )),
            Positioned(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text("last used: ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),),
                      Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: CupertinoColors.white
                          ),
                          child: Text("P", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: CupertinoColors.black),)),
                      Text(" Primary", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),),
                      Icon(CupertinoIcons.chevron_forward, size: 12, color: CupertinoColors.white,)
                    ],
                  ),
                  Text(name, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              children: [
                                CupertinoButton(child: Icon(CupertinoIcons.bubble_middle_bottom_fill, color: CupertinoColors.white,), onPressed: () async {
                                    final Uri uri = await Uri.parse('sms: $phone');
                                    await launchUrl(uri);
                                }),
                                Text('Message',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),)
                              ],
                            ),
                          ),
                        ),

                        Container(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              children: [
                                CupertinoButton(child: Icon(CupertinoIcons.phone_solid, color: CupertinoColors.white,), onPressed: () async{
                                  final Uri uri = await Uri.parse('tel: $phone');
                                  await launchUrl(uri);
                                }),
                                Text('Call',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),)
                              ],
                            ),
                          ),
                        ),

                        Container(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              children: [
                                CupertinoButton(child: Icon(CupertinoIcons.video_camera_solid, color: CupertinoColors.white,), onPressed: () async {
                                  final Uri uri = await Uri.parse('sms: $phone');
                                  await launchUrl(uri);
                                }),
                                Text('Video',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),)
                              ],
                            ),
                          ),
                        ),

                        Container(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              children: [
                                CupertinoButton(child: Icon(CupertinoIcons.mail_solid, color: CupertinoColors.white,), onPressed: () async{
                                  final Uri uri = await Uri.parse('mail to: $email');
                                  await launchUrl(uri);
                                }),
                                Text('Mail',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),)
                              ],
                            ),
                          ),
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
              GestureDetector(
                onTap: () async{
                  final Uri uri = await Uri.parse('tel: phone');
                  await launchUrl(uri);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: CupertinoColors.systemGrey.withOpacity(0.2)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('phone', style: TextStyle(fontSize: 13),),
                      Text('$phone', style: TextStyle(color: CupertinoColors.systemBlue, fontSize: 14),)
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10,),
              GestureDetector(
                onTap: () async{
                  final Uri uri = await Uri.parse('mail to: $email');
                  await launchUrl(uri);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: CupertinoColors.systemGrey.withOpacity(0.2)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('emal', style: TextStyle(fontSize: 13),),
                      Text('$email', style: TextStyle(color: CupertinoColors.systemBlue, fontSize: 14),)
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10,),
              GestureDetector(
                onTap: () async{
                  final Uri uri = await Uri.parse('sms: $phone');
                  await launchUrl(uri);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: CupertinoColors.systemGrey.withOpacity(0.2)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('sms', style: TextStyle(fontSize: 13),),
                      Text('$phone', style: TextStyle(color: CupertinoColors.systemBlue, fontSize: 14),)
                    ],
                  ),
                ),
              ),


              SizedBox(height: 10,),
              GestureDetector(
                onTap: () async{
                  final Uri uri = await Uri.parse('$url');
                  await launchUrl(uri);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: CupertinoColors.systemGrey.withOpacity(0.2)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('url', style: TextStyle(fontSize: 13),),
                      Text('$url', style: TextStyle(color: CupertinoColors.systemBlue, fontSize: 14),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    )));
  }
}
