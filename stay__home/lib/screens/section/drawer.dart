import 'package:flutter/material.dart';

class SectionDrawer extends StatefulWidget {
  @override
  _SectionDrawerState createState() => _SectionDrawerState();
}

class _SectionDrawerState extends State<SectionDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '닉네임',
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      child: Icon(Icons.edit),
                      onTap: () {
                        print("닉네임 변경");
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('집 설정'),
            onTap: () {
              print("집 설정");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.ios_share,
              color: Colors.black54,
            ),
            title: Text('공유하기'),
            onTap: () {
              print("공유하기");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.mail_outline,
              color: Colors.black54,
            ),
            title: Text('문의하기'),
            onTap: () {
              print("문의하기");
            },
          ),
        ],
      ),
    );
  }
}
