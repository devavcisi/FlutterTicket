import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:easycodestek/gelenTalepModel.dart';
import 'KatagoriModel.dart';
import 'StatuModel.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meta/meta.dart';
import 'gelenTalepDetay_page.dart';

import 'package:date_field/date_field.dart';

import 'goruntuleyenler_page.dart';
import 'loginModel.dart';
bool buttonVisible = false;

late int gelenUId;

//http://172.18.87.12:5000/api/Helping/etTicketHelperIDByTicketID?ticketID=&helperID=$gelenUId



String _searchText="";
DateTime Gbittar = DateTime.now();
DateTime Gbastar = DateTime.now().subtract(Duration(days: 3));
void main() {
  runApp(MyApp());
}


class YardimBekleyenTalepPage extends StatefulWidget {
  final String gelenbody;

  YardimBekleyenTalepPage({required this.gelenbody});
  @override
  _YardimBekleyenTalepPageState createState() => _YardimBekleyenTalepPageState();
}



class _YardimBekleyenTalepPageState extends State<YardimBekleyenTalepPage> {



  Future<List<GirisKart>> drop() async {
    gelenUId = jsonDecode(widget.gelenbody)['id'];
    buttonVisible = jsonDecode(widget.gelenbody)['yonetici'];
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

  @override
  void initState() {
    drop();

  }
  String? _selectedItemValue = '1';
  String? _selectedItemLabel = 'IBAY';


  final List<Map<String, String>> dropdownItems = [
    {'value': '1', 'label': 'IBAY'},
    {'value': 'value2', 'label': 'Option 2'},
    {'value': 'value3', 'label': 'Option 3'},
  ];

  void logGor(int ticketid ) async {


    var response = await http.post(
      Uri.parse(config.getApiUrl() +
          '/Goruntuleyenler/CreateGoruntuleyenler?ticketID=$ticketid&userID=$gelenUId'),


    );
    print( response.statusCode.toString()  +"   ticket= "+ticketid.toString()+"  user= "+gelenUId.toString());
  }


  void BaskasinaAta(int ticketId) async{

    print("23232323    $_selectedItemValue");


    var response = await http.put(
      Uri.parse(config.getApiUrl() + '/Helping/SetTicketHelperIDByTicketID?ticketID=$ticketId&helperID=$_selectedItemValue'),
    );
    print(response.statusCode);
    setState(() {
      // setState işleminizi gerçekleştirin
    });

  }

  void atamaYapYardim(int ticketId) async {
    gelenUId = jsonDecode(widget.gelenbody)['id'];
    var response = await http.put(
      Uri.parse(config.getApiUrl() +
          '/Helping/SetTicketHelperIDByTicketID?ticketID=$ticketId&helperID=$gelenUId'),
    );
    print(response.statusCode);
    setState(() {
      // setState işleminizi gerçekleştirin
    });
  }





  void _openPopup( int id) {
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

                            _selectedItemValue = newValue;

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
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                          ),
                          child: Text(
                            "Atama Yap",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Emin Misiniz?"),
                                  content: Text("Bu ticket'ı seçili kullanıya  atamak istediğinize emin misiniz?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Hayır"),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // İletişim kutusunu kapat
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Evet"),
                                      onPressed: () {

                                        BaskasinaAta(id);

                                        Navigator.of(context).pop();// İletişim kutusunu kapat
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                          },
                        )
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


  Future<List<GelenTalepKart>> yardimbekleyen() async {
    gelenUId = jsonDecode(widget.gelenbody)['id'];

    var response = await http.get(
      Uri.parse(config.getApiUrl() +
          '/Helping/GetTicketsByIsNeedHelp?needHelp=true'),
    );
    List<GelenTalepKart> personaas = [];

    if (response.statusCode == 200) {
      //response.statusCode == 200
      List<dynamic> tickets = jsonDecode(response.body);

      for (int i = 0; i < tickets.length; i++) {
        personaas.add(GelenTalepKart.fromJson(tickets[i]));
      }
    } else {
      print(response.statusCode);
    }

    return personaas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yardım Bekleyen Talepler'),
        actions: [
          Visibility(
            visible: false,
            child: IconButton(
              icon: Icon(Icons.filter_alt), // Kullanmak istediğiniz simgeyi seçebilirsiniz.
              onPressed: () {

                setState(() {

                });
                // Düğme tıklandığında gerçekleşecek eylemi burada tanımlayabilirsiniz.
              },
            ),
          ),
        ],

      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double maxWidth = constraints.maxWidth;
            final double maxHeight = constraints.maxHeight;
            final double cardHeight = maxHeight * 0.8;
            final double cardWidth = maxWidth * 0.8;
            final double filterBoxSize = cardHeight * 0.09;
            final double min = maxHeight*0.02;
            return Center(
              child: Column(
                children: [

                  SizedBox(
                    width: maxWidth,
                    height: maxHeight -min -100,
                    child: FutureBuilder<List<GelenTalepKart>>(
                      future: yardimbekleyen(),
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
                                  child: ListTile(
                                    title: Text(
                                      (index+1).toString() +'-)   Başlık: ' + item.subject,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      WrapCrossAlignment.start,
                                      children: [
                                        Text(
                                          'Şube: ' + item.sube,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Tarih: ' +
                                              item.creationDate.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Kimden: ' +
                                              item.ownerID.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          'Konu: ' +
                                              item.categoryName.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Önem: ' +
                                              item.priorityName.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        logGor(item.id);

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                GelenTalepDetay(
                                                                  id: item.id,baslik: item.subject,mesaj: item.message, onem: item.priorityName.toString(), konu: item.categoryName.toString(), kimden: item.ownerID.toString(),),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(width: 10,),
                                                    ElevatedButton(

                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.blueAccent,
                                                      ),
                                                      child: Text(
                                                        "Bana Ata",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder:
                                                              (BuildContext context) {
                                                            return AlertDialog(
                                                              title:
                                                              Text("Emin Misiniz?"),
                                                              content: Text(
                                                                  "Bu ticket'ı kendinize atamak istediğinize emin misiniz?"),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child: Text("Hayır"),
                                                                  onPressed: () {
                                                                    Navigator.of(context)
                                                                        .pop(); // İletişim kutusunu kapat
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child: Text("Evet"),
                                                                  onPressed: () {
                                                                              atamaYapYardim(item.id);



                                                                    Navigator.of(context)
                                                                        .pop(); // İletişim kutusunu kapat
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Visibility(
                                                      visible: buttonVisible,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: Colors.amber,
                                                        ),
                                                        child: Text(
                                                          "Başkasına Ata",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                        onPressed: () {


                                                          _openPopup(item.id);


                                                        },),
                                                    ),
                                                    Visibility(
                                                      visible: buttonVisible, // Bu koşula göre düğmenin görünürlüğünü ayarlayın.
                                                      child: IconButton(
                                                        icon: Icon( Icons.remove_red_eye),
                                                        onPressed: () {Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => Goruntuleyenler(id:item.id)),
                                                        );
                                                        },
                                                      ),
                                                    ),
                                                  ],



                                    ),
                                  )),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
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
      title: 'Yardım Bekleyenler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
