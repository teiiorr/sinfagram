import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sozlamalar",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: FaIcon(FontAwesomeIcons.userPlus),
            title: Text("Doʻstlarni kuzatish va taklif qilish"),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.bell),
            title: Text("Bildirishnomalar"),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.lock),
            title: Text("Maxfiylik"),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.shieldAlt),
            title: Text("Xavfsizlik"),
          ),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.user), title: Text("Hisob")),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.questionCircle),
            title: Text("Yordam"),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.exclamationCircle),
            title: Text("Ilova haqida"),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.signOutAlt),
            title: Text("Chiqish"),
          ),
          SizedBox(height: 24.0),
          Center(
            child: Text(
              "Designed & Developed by teiior",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
