import 'dart:convert';

import 'package:easycodestek/login_page.dart';
import 'package:easycodestek/rapor_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easycodestek/navbar.dart';

import 'atamaYap_page.dart';
import 'atamalar_page.dart';
import 'atananlar_page.dart';
import 'gelenTalep_page.dart';
import 'yardımBekleyenTalep.dart';

String gelenmail = "";
String gbody = "";

class HomePage extends StatefulWidget {
  final String gelenbody;
  final String gemail;
  final String password;

  HomePage({
    Key? key,
    required this.gelenbody,
    required this.gemail,
    required this.password,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDrawerOpen = true; // Panelin açık veya kapalı olduğunu takip eder
  int _selectedIndex = 0; // Seçili indeksi takip eder
  bool _telMi = false;
  var gelenB;

  late List<Widget> screens; // screens listesini bu sefer geç tanımlayacağız

  @override
  void initState() {
    super.initState();

    screens = [
      GelenTalepPage(gelenbody: widget.gelenbody),
      AtananlarPage(gelenbody: widget.gelenbody),
      AtamalarPage(),
      AtamaYapPage(gelenbody: widget.gelenbody),
      YardimBekleyenTalepPage(gelenbody: widget.gelenbody),
      RaporPage(),

    ];
  }


  double groupAlignment = -1.0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  responsiveNavRail() {
    return Row(
      children: [
        if (!_isDrawerOpen)
          NavigationRail(
            backgroundColor: Colors.blue,
            selectedIndex: _selectedIndex,
            groupAlignment: groupAlignment,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: labelType,
            leading: showLeading
                ? FloatingActionButton(
                    elevation: 0,
                    onPressed: () {
                      // Add your onPressed code here!
                    },
                    child: const Icon(Icons.add),
                  )
                : const SizedBox(),
            trailing: showTrailing
                ? IconButton(
                    onPressed: () {
                      // Add your onPressed code here!
                    },
                    icon: const Icon(Icons.more_horiz_rounded),
                  )
                : const SizedBox(),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                ),
                selectedIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                label: Text(''),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.get_app_outlined,
                  color: Colors.white,
                ),
                selectedIcon: Icon(
                  Icons.get_app,
                  color: Colors.white,
                ),
                label: Text(''),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.all_inbox_outlined,
                  color: Colors.white,
                ),
                selectedIcon: Icon(
                  Icons.all_inbox,
                  color: Colors.white,
                ),
                label: Text(''),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.read_more,
                  color: Colors.white,
                ),
                selectedIcon: Icon(
                  Icons.read_more,
                  color: Colors.white,
                ),
                label: Text(''),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.speaker_notes_outlined,
                  color: Colors.white,
                ),
                selectedIcon: Icon(
                  Icons.speaker_notes,
                  color: Colors.white,
                ),
                label: Text(''),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.leaderboard_outlined,
                  color: Colors.white,
                ),
                selectedIcon: Icon(
                  Icons.leaderboard,
                  color: Colors.white,
                ),
                label: Text(''),
              ),
            ],
          ),
      ],
    );
  }

  bool selectedColor = false;


  responsiveDrawer(bool _drawerAcikMi) {
    return Row(
      children: [
        if (!_isDrawerOpen && _telMi == false) responsiveNavRail(),
        if (_isDrawerOpen)
          Drawer(
            backgroundColor: Colors.blue,
            surfaceTintColor: Colors.white,
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    gelenmail,
                    style: TextStyle(fontSize: 20),
                  ),
                  accountEmail: Text(''),
                  currentAccountPicture: Image(
                    image: AssetImage('assets/images/easylogo.png'),
                    height: 100,
                    width: 100,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue, // Header arkaplan rengi
                  ),
                  currentAccountPictureSize: Size.square(50), // Yeni satır
                  // Yeni satır
                  margin: EdgeInsets.zero,
                ),

                ListTile(
                  leading: Icon(Icons.email, color: _selectedIndex == 0 ? Colors.blue : Colors.white),
                  tileColor: _selectedIndex==0 ? Colors.white : Colors.blue,
                  title: Text(
                    'Gelen Talepler',
                    style: TextStyle(
                      color: _selectedIndex==0 ? Colors.blue : Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                      _isDrawerOpen = _drawerAcikMi; // Paneli kapat
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(
                    Icons.get_app,
                    color: _selectedIndex==1 ? Colors.blue : Colors.white,
                  ),
                  tileColor: _selectedIndex==1 ? Colors.white : Colors.blue,
                  title: Text(
                    'Bana Atananlar',
                    style: TextStyle(
                      color: _selectedIndex==1 ? Colors.blue : Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                      _isDrawerOpen = _drawerAcikMi; // Paneli kapat
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(Icons.all_inbox, color: _selectedIndex==2 ? Colors.blue : Colors.white),
                  tileColor: _selectedIndex==2 ? Colors.white : Colors.blue,
                  title: Text(
                    'Tüm Atamalar',
                    style: TextStyle(
                      color: _selectedIndex==2 ? Colors.blue : Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                      _isDrawerOpen = _drawerAcikMi; // Paneli kapat
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(Icons.read_more, color: _selectedIndex==3 ? Colors.blue : Colors.white),
                  tileColor: _selectedIndex==3 ? Colors.white : Colors.blue,
                  title: Text(
                    'Atama Yap',
                    style: TextStyle(
                      color: _selectedIndex==3 ? Colors.blue : Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                      _isDrawerOpen = _drawerAcikMi; // Paneli kapat
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(Icons.speaker_notes, color: _selectedIndex==4 ? Colors.blue : Colors.white),
                  tileColor: _selectedIndex==4 ? Colors.white : Colors.blue,
                  title: Text(
                    'Yardım Bekleyen Ticket',
                    style: TextStyle(
                      color: _selectedIndex==4 ? Colors.blue : Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 4;
                      _isDrawerOpen = _drawerAcikMi; // Paneli kapat
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(Icons.leaderboard, color: _selectedIndex==5 ? Colors.blue : Colors.white),
                  tileColor: _selectedIndex==5 ? Colors.white : Colors.blue,
                  title: Text(
                    'Performans Raporu',
                    style: TextStyle(
                      color: _selectedIndex==5 ? Colors.blue : Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 5;
                      _isDrawerOpen = _drawerAcikMi; // Paneli kapat
                    });
                  },
                ),

                SizedBox(
                  height: 70,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Çıkış Yap',
                        style: TextStyle(color: Colors.white70)))
                // Diğer menü öğeleri
              ],
            ),
          ),
        VerticalDivider(
          width: 0.7,
          color: Colors.indigo,
        ), // Panel ile içeriği ayırmak için bir bölücü
        Expanded(
          child: Center(
            child: screens[_selectedIndex],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    gelenmail = widget.gemail;
    gbody = widget.gelenbody;
    gelenB = jsonDecode(gbody);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Easyco Destek Talepleri'),
          backgroundColor: CupertinoColors.activeBlue,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(_isDrawerOpen ? Icons.arrow_back : Icons.menu),
              onPressed: () {
                setState(() {
                  _isDrawerOpen = !_isDrawerOpen; // Paneli aç/kapat
                });
              },
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              _telMi = true;
              return responsiveDrawer(false);

            } else {
              _telMi = false;
              return responsiveDrawer(true);
            }
          },
        ),
      ),
    );
  }
}

