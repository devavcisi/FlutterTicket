import 'dart:async';
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
late int gelenUId;
late bool buttonVisible = false ;
String bastar = "2022-01-01";
String bittar = "2024-01-01";
bool vsblt = true;
String ktgr = "";
String statu="";
String atama="";
String _searchText="";
DateTime Gbittar = DateTime.now();
DateTime Gbastar = DateTime.now().subtract(Duration(days: 3));
int yeniVeri = 0;
void main() {
  runApp(MyApp());
}


class GelenTalepPage extends StatefulWidget {
  final String gelenbody;

  GelenTalepPage({required this.gelenbody});
  @override
  _GelenTalepPageState createState() => _GelenTalepPageState();
}

class _GelenTalepPageState extends State<GelenTalepPage> {

  Timer? timer;
  @override
  void initState() {
    super.initState();
    ktgr=_selectedItemValueKategori.toString();
    statu=_selectedItemValueStatu.toString();
    atama=_selectedItemValueAtama.toString();

    dropStatu();
    dropKtgr();

    timer = Timer.periodic(Duration(seconds: 20), (Timer t) {
      print('aşağıda: $yeniVeri');
      print('Timer a girdi');
      getozelgelenlerbilgi();
      setState(() {

      });
    });
  }
  void setTamamlandi(int ticketId) async {
    gelenUId = jsonDecode(widget.gelenbody)['id'];
    var response = await http.post(
      Uri.parse(config.getApiUrl()+'/TicketFlow/AddFlow?ticketID=$ticketId&supporterID=$gelenUId&answer=İşlem Yapılıyor&statuID=3'),
    );
    setState(() {

    });


  }

  @override
  void dispose() {
    super.dispose();
    print('dispose etti');
    timer?.cancel();
  }

  void atamaYap(int ticketId) async {
    gelenUId = jsonDecode(widget.gelenbody)['id'];
    var response = await http.put(
      Uri.parse(config.getApiUrl() +
          '/Ticket/AtamaYap?ticketID=$ticketId&userID=$gelenUId'),
    );
    print(response.statusCode);
    setState(() {
      // setState işleminizi gerçekleştirin
    });
  }


  Future<List<GelenTalepKartGoruldulu>> getozelgelenlerbilgi() async {
    bool goruldu;
    print('fonksiyona girdi');
    gelenUId = jsonDecode(widget.gelenbody)['id'];
    buttonVisible = jsonDecode(widget.gelenbody)['yonetici'];
    var response = await http.get(
      Uri.parse(config.getApiUrl() +
          '/Ticket/GetTicketsByFilter?sube=*&categoryID=$ktgr&ownerID=1&statuID=$statu&atama=$atama&baslangic=$bastar&bitis=$bittar'),
    );
    List<GelenTalepKartGoruldulu> personaas = [];

    if (response.statusCode == 200) {
      //response.statusCode == 200
      List<dynamic> tickets = jsonDecode(response.body);

      yeniVeri = tickets.length;
      print('ticket uzunluk ${yeniVeri}');


      for (int i = tickets.length-1; i > -1; i--) {
        goruldu = await getGoruntuleyenler(tickets[i]['id']);
        //print(tickets[i].toString().replaceAll('}', ', $goruldu }'));
        personaas.add(GelenTalepKartGoruldulu.fromJsonGoruldulu(tickets[i],goruldu));
        //print('futurue ${goruldu} ticket id: ${tickets[i]['id']}');
      }
    } else {
      print(response.statusCode);
    }
    return personaas;
  }

  void dropStatu() async {
    var response = await http.get(
      Uri.parse(config.getApiUrl() +'/Statu/GetStatus'),
    );
    List<Statu> personaas = [];

    if (response.statusCode == 200) {
      //response.statusCode == 200
      dropdownItemsStatu.clear();
      List<dynamic> tickets = jsonDecode(response.body);
      for (int i = 0; i < tickets.length; i++) {
        personaas.add(Statu.fromJson(tickets[i]));
       dropdownItemsStatu.add({
          'value': tickets[i]['id'].toString(),
          'label': tickets[i]['statu'],
        });
      }
    }
        setState(() {

        });

  }
  void dropKtgr() async {
    var response = await http.get(
      Uri.parse(config.getApiUrl() +'/Category/GetAllCategories'),
    );
    List<Kategori> personaas = [];

    if (response.statusCode == 200) {
      //response.statusCode == 200
      dropdownItemsKategori.clear();
      List<dynamic> tickets = jsonDecode(response.body);
      for (int i = 0; i < tickets.length; i++) {
        personaas.add(Kategori.fromJson(tickets[i]));
        dropdownItemsKategori.add({
          'value': tickets[i]['id'].toString(),
          'label': tickets[i]['name'],
        });
      }
    }
    setState(() {

    });

  }




  void logGor(int ticketid ) async {
    gelenUId = jsonDecode(widget.gelenbody)['id'];

    var response = await http.post(
      Uri.parse(config.getApiUrl() +
          '/Goruntuleyenler/CreateGoruntuleyenler?ticketID=$ticketid&userID=$gelenUId'),


    );
    print( response.statusCode.toString()  +"   ticket= "+ticketid.toString()+"  user= "+gelenUId.toString());
  }

  Future<bool> getGoruntuleyenler(int ticketid) async {

    int gordumu = 0;
    gelenUId = jsonDecode(widget.gelenbody)['id'];
    var response = await http.get(
      Uri.parse(config.getApiUrl() + '/Goruntuleyenler/GetGoruntuleyenlerByTicketID?ticketID=${ticketid}'),
    );
    if(response.statusCode == 200){
      List<dynamic> tickets = jsonDecode(response.body);
      for (int i = 0; i < tickets.length; i++) {
        if(tickets[i]['userID'] == gelenUId)
          {
            gordumu++;
          }
//sonra bak duruma göre break continue
      }

    }
    if(gordumu > 0){
      //print('Görmüş ${ticketid}');
      return true;
    }
    else{
      //print('görmedi ${ticketid}');
      return false;
    }


  }




  String? _selectedItemValueStatu = '1';
  String? _selectedItemLabelStatu = 'Yeni';

  String? _selectedItemValueAtama = 'false';
  String? _selectedItemLabelAtama = 'Atanmamış';

  String? _selectedItemValueKategori = '1';
  String? _selectedItemLabelKategori = 'Yemeksepeti Entegrasyon';





  final List<Map<String, String>> dropdownItemsKategori = [
    {'value': '1', 'label': 'Yemeksepeti Entegrasyon'},
    {'value': 'value2', 'label': 'Option 2'},

  ];
  final List<Map<String, String>> dropdownItemsStatu = [
    {'value': '1', 'label': 'IBAY'},
    {'value': 'value2', 'label': 'Option 2'},
    {'value': 'value3', 'label': 'Option 3'},
  ];
  final List<Map<String, String>> dropdownItemsAtama = [
  {'value': 'true', 'label': 'Atanmış'},
  {'value': 'false', 'label': 'Atanmamış'},

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gelen Talepler'),
        actions: [
          Visibility(
            visible: buttonVisible,
            child: IconButton(
              icon: Icon(Icons.filter_alt), // Kullanmak istediğiniz simgeyi seçebilirsiniz.
              onPressed: () {

                setState(() {
                  vsblt=!vsblt;
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
                  Visibility(
                    visible: !vsblt,
                    child: SizedBox(
                        width: maxWidth,
                        height: 100+min,
                        child: Card(
                          shadowColor: Colors.blue,
                          child: Container(
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              verticalDirection: VerticalDirection.down,
                              children: [



                                Container(
                                  width: 500,
                                  child: Row(
                                    children: [
                                      Text("Kategori"),
                                      SizedBox(width: 10,),
                                      DropdownButton<String>(
                                        value: _selectedItemValueKategori,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedItemValueKategori = newValue;

                                            _selectedItemLabelKategori = dropdownItemsKategori
                                                .firstWhere((item) =>
                                            item['value'] == newValue)
                                                .values
                                                .first;

                                            print(_selectedItemValueKategori);
                                          });
                                        },
                                        items: dropdownItemsKategori
                                            .map<DropdownMenuItem<String>>(
                                                (Map<String, String> item) {
                                              return DropdownMenuItem<String>(
                                                value: item['value']!,
                                                child: Text(item['label']!),
                                              );
                                            }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Row(
                                    children: [
                                      Text("Statü"),
                                      SizedBox(width: 10,),
                                      DropdownButton<String>(
                                        value: _selectedItemValueStatu,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedItemValueStatu = newValue;

                                            _selectedItemLabelStatu = dropdownItemsStatu
                                                .firstWhere((item) =>
                                            item['value'] == newValue)
                                                .values
                                                .first;

                                            print(_selectedItemValueStatu);
                                          });
                                        },
                                        items: dropdownItemsStatu
                                            .map<DropdownMenuItem<String>>(
                                                (Map<String, String> item) {
                                              return DropdownMenuItem<String>(

                                                value: item['value']!,
                                                child: Text(item['label']!),
                                              );
                                            }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Row(
                                    children: [
                                      Text("Atanma"),
                                      SizedBox(width: 10,),
                                      DropdownButton<String>(
                                        value: _selectedItemValueAtama,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedItemValueAtama = newValue;

                                            _selectedItemLabelAtama = dropdownItemsAtama
                                                .firstWhere((item) =>
                                            item['value'] == newValue)
                                                .values
                                                .first;

                                          });
                                        },
                                        items: dropdownItemsAtama
                                            .map<DropdownMenuItem<String>>(
                                                (Map<String, String> item) {
                                              return DropdownMenuItem<String>(
                                                value: item['value']!,
                                                child: Text(item['label']!),
                                              );
                                            }).toList(),
                                      ),
                                    ],
                                  ),
                                ),

                              Column(
                                children: [
                                  SizedBox(height: 8,),
                                  Container(

                                    width: maxWidth * 0.12,
                                    height: maxHeight * 0.07,
                                    child: DateTimeFormField(
                                      initialValue:
                                      DateTime.now().subtract(Duration(days: 3)),
                                      decoration: const InputDecoration(
                                        hintStyle: TextStyle(color: Colors.black45),
                                        errorStyle: TextStyle(color: Colors.redAccent),
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.event_note),
                                        labelText: 'Başlangıç. tarihi',
                                      ),
                                      mode: DateTimeFieldPickerMode.date,
                                      autovalidateMode: AutovalidateMode.always,
                                      onDateSelected: (DateTime value) {
                                        bastar = value.year.toString() +
                                            "-" +
                                            value.month.toString() +
                                            "-" +
                                            value.day.toString();
                                        Gbastar = value;
                                        print(value);
                                      },
                                    ),
                                  ),


                                ],
                              ),
                                SizedBox(width: 6,),
                                Column(
                                  children: [
                                    SizedBox(height: 8,),
                                    Container(
                                      width: maxWidth * 0.12,
                                      height: maxHeight * 0.07,
                                      child: DateTimeFormField(
                                        initialValue: DateTime.now(),
                                        decoration: const InputDecoration(
                                          hintStyle: TextStyle(color: Colors.black45),
                                          errorStyle: TextStyle(color: Colors.redAccent),
                                          border: OutlineInputBorder(),
                                          suffixIcon: Icon(Icons.event_note),
                                          labelText: 'Bitiş Tarihi',
                                        ),
                                        mode: DateTimeFieldPickerMode.date,
                                        autovalidateMode: AutovalidateMode.always,
                                        onDateSelected: (DateTime value) {
                                          bittar = value.year.toString() +
                                              "-" +
                                              value.month.toString() +
                                              "-" +
                                              value.day.toString();
                                          Gbittar = value;
                                          print(value);
                                        },
                                      ),
                                    ),


                                  ],
                                ),
                                SizedBox(width: 16,),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.orange,
                                  ),
                                  child: Text(
                                    "Filtrele",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () { ktgr = _selectedItemValueKategori.toString();
                                   statu=_selectedItemValueStatu.toString();
                                   atama=_selectedItemValueAtama.toString();
                                   setState(() {

                                   });
                                   },
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: maxWidth,
                    height: maxHeight -min -100,
                    child: FutureBuilder<List<GelenTalepKartGoruldulu>>(
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
                                      color: item.gorulduMu != true ? Colors.blue.shade100 : Colors.white,
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
                                          Container(
                                            width: 250,
                                            padding: EdgeInsets.only(left: 20),

                                              child:Column(
                                                children: [
                                                  Row(

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
                                                          setState(() {
                                                            
                                                          });
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
                                                                      atamaYap(item.id);
                                                                      setTamamlandi(item.id);

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
                                                      Visibility(
                                                        visible:  buttonVisible , // Bu koşula göre düğmenin görünürlüğünü ayarlayın.
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


                                                  )

                                              ]),




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

class flowAttachment {
  final int ticketID;
  final int supporterID;
  final String? answer;
  final int statuID;
  final String? attachment;
  final String? fileName;
  final String? type;

  flowAttachment({
    required this.ticketID,
    required this.supporterID,
    this.answer,
    required this.statuID,
    this.attachment,
    this.fileName,
    this.type,
  });

  Map<String, dynamic> toJson() {
    String fileNameWithoutExtension = fileName?.split('.').first ?? '';
    Map<String, dynamic> jsonData = {
      'ticketID': ticketID,
      'supporterID': supporterID,
      'answer': answer,
      'statuID': statuID,
      'attachment': attachment,
      'fileName': fileNameWithoutExtension,
      'type': type,
    };

    // print(jsonData); // JSON verisini yazdır

    return jsonData;
  }
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gelen Talepler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
