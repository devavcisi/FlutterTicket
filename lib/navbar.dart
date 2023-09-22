import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String nemail;

  NavBar({
    Key? key,
    required this.nemail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              nemail,
              style: TextStyle(fontSize: 20),
            ),
            accountEmail: Text(''),
            currentAccountPicture: Image(
              image: AssetImage('assets/images/easylogo.png'),
              height: 100,
              width: 100,
            ),
          ),
          ListTile(
              leading: Icon(Icons.email),
              title: Text('Destek Talepleri'),
              onTap: () => print('object')),
          SizedBox(
            height: 20,
          ),
          ListTile(
              leading: Icon(Icons.get_app),
              title: Text('Bana Atananlar'),
              onTap: () => print('object')),
          SizedBox(
            height: 20,
          ),
          ListTile(
              leading: Icon(Icons.read_more),
              title: Text('Atama Yap'),
              onTap: () => print('object')),
          SizedBox(
            height: 20,
          ),
          ListTile(
              leading: Icon(Icons.leaderboard),
              title: Text('Raporlar'),
              onTap: () => print('object')),
          SizedBox(
            height: 70,
          ),
          TextButton(onPressed: () => print('object'), child: Text('Çıkış Yap'))
        ],
      ),
    );
  }
}
