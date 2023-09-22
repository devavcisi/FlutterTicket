import 'dart:convert';

import 'package:easycodestek/share_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'homeUser_page.dart';
import 'home_page.dart';
import 'loginModel.dart';

bool isLoginLoad = false;

String email = '';
String password = '';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passEditingController = TextEditingController();
  bool _isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSavedLoginCredentials();
  }

  void _loadSavedLoginCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? remail = prefs.getString('email');
    String? rpassword = prefs.getString('password');
    if (remail != null && rpassword != null) {
      setState(() {
        email = remail;
        password = rpassword;
        _emailEditingController.text = remail;
        _passEditingController.text = rpassword;
        _isChecked = true;
      });
    }
  }

  void _saveLoginCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_isChecked) {
      await prefs.setString('email', _emailEditingController.text);
      await prefs.setString('password', _passEditingController.text);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  Future fetchloginkontrol(BuildContext contextB) async {
    var response = await http.post(
        Uri.parse(
            config.getApiUrl() + '/User/Login?username=$email&password=$password'),
            // '/UserKontrol?uname=$email&upass=$password'),
        );

    if (response.statusCode == 200) {
      setState(() {
        isLoginLoad = false;
      });
      String gelenbody = response.body;

      //print(response.body);
      var tickets = jsonDecode(response.body);

      if(tickets['yonetici'] == true){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                gelenbody: gelenbody,
                gemail: tickets['name'],
                password: password,
              )),
        );
      }else
        {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePageUser(
                  gelenbody: gelenbody,
                  gemail: tickets['name'],
                  password: password,
                )),
          );
        }


    } else {
      setState(() {
        isLoginLoad = false;
      });

      shareFunction().showAlertSimple(
          contextB, 'Hata', 'Hatalı Kullanıcı Adı ya da Şifre', 'Tamam');
      //  print("hata var");
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
      decoration: const BoxDecoration(
          /*gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.blue,
          Colors.deepOrangeAccent,
        ],
      )*/
          ),
      child: Scaffold(

          //backgroundColor: Colors.transparent,
          body: SafeArea(child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth;
        final double maxHeight = constraints.maxHeight;
        final double cardHeight = maxHeight * 0.8;
        final double cardWidth = maxWidth * 0.8;

        if (maxHeight < 600) {
          return Center(
            child: Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeBlue,
                  ),
                  child: SafeArea(
                    child: Center(
                      child: Card(
                        color: Colors.white.withOpacity(0.4),
                        elevation: 20,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: SizedBox(
                          width: maxWidth * 0.9,
                          height: maxHeight * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                image: AssetImage('assets/images/easylogo.png'),
                                height: 100,
                                width: 100,
                              ),
                              SizedBox(
                                height: maxHeight * 0.03,
                              ),
                              const Text(
                                "Hoşgeldiniz",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 36),
                              ),
                              SizedBox(
                                height: maxHeight * 0.02,
                              ),
                              const Text(
                                "Lütfen kullanıcı girişi yapınız",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: maxHeight * 0.02,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _emailEditingController,
                                      onChanged: (value) {
                                        email = value;
                                      },
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Kullanıcı Adınız',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _passEditingController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: true,
                                      onChanged: (value) {
                                        password = value;
                                      },
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Şifreniz',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 75),
                                child: CheckboxListTile(
                                  title: Text('Beni Hatırla'),
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 0, bottom: 10, right: 0, top: 20),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextButton(
                                    child: isLoginLoad
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text('Giriş',
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                            )),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _saveLoginCredentials();
                                      }
                                      setState(() {
                                        isLoginLoad = true;
                                      });
                                      fetchloginkontrol(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          );
        } else {
          return Center(
            child: Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeBlue,
                  ),
                  child: SafeArea(
                    child: Center(
                      child: Card(
                        color: Colors.white.withOpacity(0.4),
                        elevation: 20,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: SizedBox(
                          width: 400,
                          height: 600,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                image: AssetImage('assets/images/easylogo.png'),
                                height: 100,
                                width: 100,
                              ),
                              SizedBox(
                                height: maxHeight * 0.03,
                              ),
                              const Text(
                                "Hoşgeldiniz",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 36),
                              ),
                              SizedBox(
                                height: maxHeight * 0.02,
                              ),
                              const Text(
                                "Lütfen kullanıcı girişi yapınız",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: maxHeight * 0.02,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _emailEditingController,
                                      onChanged: (value) {
                                        email = value;
                                      },
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Kullanıcı Adınız',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _passEditingController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: true,
                                      onChanged: (value) {
                                        password = value;
                                      },
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Şifreniz',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 75),
                                child: CheckboxListTile(
                                  title: Text('Beni Hatırla'),
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 0, bottom: 10, right: 0, top: 20),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextButton(
                                    child: isLoginLoad
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text('Giriş',
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                            )),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _saveLoginCredentials();
                                      }
                                      setState(() {
                                        isLoginLoad = true;
                                      });
                                      fetchloginkontrol(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          );
        }
      }))),
    ));
  }
}
