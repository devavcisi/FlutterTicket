import 'package:flutter/material.dart';
import 'package:easycodestek/gelenTalepModel.dart';
import 'banaAtananModel.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'gelenTalepDetay_page.dart';
import 'loginModel.dart';

void main() {
  runApp(MyApp());
}
int id = 0;
class AtamalarPage extends StatefulWidget {
  @override
  _AtamalarPageState createState() => _AtamalarPageState();
}



class _AtamalarPageState extends State<AtamalarPage> {

  @override
  void initState() {
    drop();
  }
  Future<List<BanaAtananKart>> getozelgelenlerbilgi() async {
    var response = await http.get(
      Uri.parse(config.getApiUrl()+ '/Ticket/TumAtananlar'),
    );
    List<BanaAtananKart> personaas = [];

    if (response.statusCode == 200) {
      //response.statusCode == 200

      List<dynamic> movies = jsonDecode(response.body);

      for (int i = 0; i < movies.length; i++) {
        personaas.add(BanaAtananKart.fromJson(movies[i]));
      }
    }

    return personaas;
  }

  void ata() async {
    var response = await http.put(
      Uri.parse(config.getApiUrl() +
          '/Ticket/AtamaYap?ticketID=$id&userID=$_selectedItemValue'),
    );

    if (response.statusCode == 200) {

      setState(() {

      });

    }

  }

  Future<List<GirisKart>> drop() async {
    var response = await http.get(
      Uri.parse(config.getApiUrl() + '/User/GetAllUsers'),
    );
    List<GirisKart> personaas = [];

    if (response.statusCode == 200) {
      //response.statusCode == 200

      dropdownItems.clear();
      List<dynamic> tickets = jsonDecode(response.body);
      for (int i = 0; i < tickets.length; i++) {
        personaas.add(GirisKart.fromJson(tickets[i]));

        print(tickets[i]['name']);

        dropdownItems.add({
          'value': tickets[i]['id'].toString(),
          'label': tickets[i]['name']
        });
      }
    }

    return personaas;
  }



  String? _selectedItemValue = '1';
  String? _selectedItemLabel = 'IBAY';

  final List<Map<String, String>> dropdownItems = [
    {'value': '1', 'label': 'IBAY'},
    {'value': 'value2', 'label': 'Option 2'},
    {'value': 'value3', 'label': 'Option 3'},
  ];

  void _openPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateInside) {
            return AlertDialog(
            title: Text('Atama Yap'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: DropdownButton<String>(
                    value: _selectedItemValue,
                    onChanged: (String? newValue) {
                      setStateInside(() {
                        _selectedItemValue = newValue!;
                        _selectedItemLabel = dropdownItems
                            .firstWhere((item) => item['value'] == newValue)
                            .values
                            .first;
                        print(_selectedItemValue);
                      });
                    },
                    items: dropdownItems.map<DropdownMenuItem<String>>(
                            (Map<String, String> item) {
                          return DropdownMenuItem<String>(
                            value: item['value']!,
                            child: Text(item['label']!),
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ata();
                        Navigator.pop(context);
                      },
                      child: Text('Atama Yap'),
                    ),
                  ],
                ),
              ],
            ),
            );

          }
        );

      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tüm Atamalar'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double maxWidth = constraints.maxWidth;
            final double maxHeight = constraints.maxHeight;
            final double cardHeight = maxHeight * 0.8;
            final double cardWidth = maxWidth * 0.8;

            return Center(
              child: FutureBuilder<List<BanaAtananKart>>(
                future: getozelgelenlerbilgi(),
                builder: (BuildContext context, snapshot) {
                  return snapshot.data == null
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data![index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3.0),
                        child: Card(
                            child:
                            ListTile(
                              title: Text(
                                (index+1).toString() +'-)   Başlık: ' + item.subject,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  Text(
                                    'Şube: ' + item.sube,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Tarih: ' + item.creationDate.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Kimden: ' + item.ownerID.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    'Konu: ' + item.categoryName.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Önem: ' + item.priorityName.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Atanan Kişi: ' + item.assignedName.toString()+ ' '+  item.assignedLastName.toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              trailing: Wrap(
                                spacing: 8.0,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    child: Text(
                                      "Detay",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GelenTalepDetay(id:item.id,baslik: item.subject,mesaj: item.message, onem: item.priorityName.toString(), konu: item.categoryName.toString(), kimden: item.ownerID.toString(),),
                                        ),
                                      );
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.amber,
                                    ),
                                    child: Text(
                                      "Atananı Değiştir",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      id = item.id;

                                      _openPopup();
                                    },
                                  ),
                                ],
                              ),
                            )


                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tüm Atamalar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AtamalarPage(),
    );
  }
}
