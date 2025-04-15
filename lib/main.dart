import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';
import 'variables.dart';
import 'contact.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

void main() async{
  await Hive.initFlutter();
  var box= await Hive.openBox('database');
  runApp(CupertinoApp(
    theme: CupertinoThemeData(
      brightness: Brightness.dark
    ),
    debugShowCheckedModeBanner: false,
    home: Homepage(),));
}


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var box = Hive.box('database');
  List<dynamic> contacts = [
  ];
  @override
  void initState() {
    if (box.get('contacts') == null){
      print('empty list');
    }else{
     setState(() {
       contacts = box.get('contacts');
       print(contacts);
     });
    }
    super.initState();
  }
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _phone= TextEditingController();
  TextEditingController _email= TextEditingController();
  TextEditingController _url = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: CupertinoButton(child: Icon(CupertinoIcons.add), onPressed: (){
            showCupertinoModalPopup(context: context, builder: (context){
              return CupertinoActionSheet(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(child:Text('Cancel'), onPressed: (){
                      Navigator.pop(context);
                    }),
                    Text('New Contact'),
                    CupertinoButton(child:Text('Done'), onPressed: (){
                      setState(() {
                        contacts.add(
                          {
                            "name" : _fname.text + " " + _lname.text,
                            "phone" : _phone.text,
                            "email" : _email.text,
                            "url" : _url.text,
                            "photo" : "https://plus.unsplash.com/premium_photo-1689530775582-83b8abdb5020?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cmFuZG9tJTIwcGVyc29ufGVufDB8fDB8fHww",
                          },);
                        box.put('contacts', contacts);
                        print(box.get('contacts'));


                      });
                      _fname.text ="";
                      _lname.text ="";
                      _phone.text ="";
                      _email.text ="";
                      _url.text ="";
                      Navigator.pop(context);
                    }),
                  ],
                ),

                message: Column(
                  children: [
                    Icon(CupertinoIcons.person_circle_fill, color: CupertinoColors.white, size: 200,),
                    CupertinoButton(child: Text('Add Photo'), onPressed: (){

                    }),

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
                          Divider(color: CupertinoColors.systemGrey.withOpacity(0.2),),
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
                    SizedBox(height: 20,),
                    CupertinoTextField(
                      prefix: Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.systemGreen,),
                      controller: _phone,
                      placeholder: 'add phone',
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey.withOpacity(0.1),
                      ),
                    ),
                    SizedBox(height: 20,),
                    CupertinoTextField(
                      prefix: Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.systemGreen,),
                      controller: _email,
                      placeholder: 'add email',
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey.withOpacity(0.1),
                      ),
                    ),
                    SizedBox(height: 20,),
                    CupertinoTextField(
                      prefix: Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.systemGreen,),
                      controller: _url,
                      placeholder: 'add url',
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey.withOpacity(0.1),
                      ),
                    ),




                    SizedBox(height: double.maxFinite,)
                  ],
                ),

              );
            });
          }),
        ),
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
                children: [
            Row(
              children: [
                Text('Contacts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
              ],
            ),
                  SizedBox(height: 15,),
                  CupertinoTextField(
                    placeholder: 'Search',
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    prefix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(CupertinoIcons.search, color: CupertinoColors.systemGrey2, size: 21,),
                    ),
                    suffix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(CupertinoIcons.mic_fill, color: CupertinoColors.systemGrey2, size: 21,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Divider(color: CupertinoColors.systemGrey.withOpacity(0.3),),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(12,9,12,9),

                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey,
                          borderRadius: BorderRadius.circular(50)

                        ),
                        child: Text(' G', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
                      ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Group Leader Name', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('My Card', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),)
                          ],
                        )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Divider(color: CupertinoColors.systemGrey.withOpacity(0.3),),
                  Expanded(child: ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, int index){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              name = contacts[index]['name'];
                              phone = contacts[index]['phone'];
                              email = contacts[index]['email'];
                              url = contacts[index]['url'];
                              photo = contacts[index]['photo'];
                            });
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => Contact()));
                          },
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(contacts[index]['name'] == " "? contacts[index]['phone'] : contacts[index]['name']),
                                Divider(color: CupertinoColors.systemGrey.withOpacity(0.3),),
                              ],
                            ),
                          ),
                        );
                  })),



                ],
              ),
        )));
  }
}
