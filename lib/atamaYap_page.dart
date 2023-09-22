import 'package:easycodestek/loginModel.dart';
import 'package:flutter/material.dart';
import 'package:easycodestek/gelenTalepModel.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'gelenTalepDetay_page.dart';

void main() {
  runApp(MyApp());
}

int id = 0;
int gelenUId=0;

class AtamaYapPage extends StatefulWidget {
  final String gelenbody;

  AtamaYapPage({required this.gelenbody});
  @override
  _AtamaYapPageState createState() => _AtamaYapPageState();
}

class _AtamaYapPageState extends State<AtamaYapPage> {
  Future<List<GelenTalepKart>> getozelgelenlerbilgi() async {
    var response = await http.get(
      Uri.parse(config.getApiUrl() +
          '/Ticket/GetAllTicketsByStatusByIsAssigned?statuID=1&isAssigned=false'),
    );
    List<GelenTalepKart> personaas = [];

    if (response.statusCode == 200) {
      //response.statusCode == 200

      List<dynamic> tickets = jsonDecode(response.body);
      for (int i = 0; i < tickets.length; i++) {
        personaas.add(GelenTalepKart.fromJson(tickets[i]));
      }
    }

    return personaas;
  }
  void atamaYap(int ticketId) async{

    gelenUId = jsonDecode(widget.gelenbody)['id'];
    var response = await http.put(
      Uri.parse(config.getApiUrl() + '/Ticket/AtamaYap?ticketID=$ticketId&userID=$gelenUId'),
    );
    print(response.statusCode);
    setState(() {
      // setState işleminizi gerçekleştirin
    });

  }
  void setTamamlandi() async {

    var response = await http.post(
      Uri.parse(config.getApiUrl()+'/TicketFlow/AddFlow?ticketID=$id&supporterID=$_selectedItemValue&answer=İşlem Yapılıyor&statuID=3'),
    );
    setState(() {

    });


  }
  void ata() async {
    var response = await http.put(

      Uri.parse(config.getApiUrl() +
          '/Ticket/AtamaYap?ticketID=$id&userID=$_selectedItemValue'),


    );

    if (response.statusCode == 200) {



    }
       setState(() {

    });


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

  @override
  void initState() {
    drop();
    print(_selectedItemLabel.toString());
  }

  String? _selectedItemValue = '1';
  String? _selectedItemLabel = 'IBAY';





  final List<Map<String, String>> dropdownItems = [
    {'value': '1', 'label': 'IBAY'},
    {'value': 'value2', 'label': 'Option 2'},
    {'value': 'value3', 'label': 'Option 3'},
  ];

  TextEditingController _responseController = TextEditingController();

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

                                        ata();
                                        setTamamlandi();


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atama Yap'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double maxWidth = constraints.maxWidth;
            final double maxHeight = constraints.maxHeight;
            final double cardHeight = maxHeight * 0.8;
            final double cardWidth = maxWidth * 0.8;

            return Center(
              child: FutureBuilder<List<GelenTalepKart>>(
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
                                  child: ListTile(
                                title: Text(
                                  (index+1).toString() +'-)   Başlık: ' + item.subject,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    Text(
                                      'Şube: ' + item.subject,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Tarih: ' + item.subject,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Kimden: ' + item.subject ,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      'Konu: ' + item.subject,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Atanan Kişi: ' + item.subject,
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
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                GelenTalepDetay(id: item.id,baslik: item.subject,mesaj: item.message, onem: item.priorityName.toString(), konu: item.categoryName.toString(), kimden: item.ownerID.toString(),),
                                          ),
                                        );
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blueAccent,
                                      ),
                                      child: Text(
                                        "Bana Ata",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Emin Misiniz?"),
                                              content: Text("Bu ticket'ı kendinize atamak istediğinize emin misiniz?"),
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

                                                    atamaYap(item.id);

                                                    Navigator.of(context).pop(); // İletişim kutusunu kapat
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.amber,
                                      ),
                                      child: Text(
                                        "Atama Yap",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        id = item.id;

                                        _openPopup();


                                      },
                                    ),
                                  ],
                                ),
                              )),
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
