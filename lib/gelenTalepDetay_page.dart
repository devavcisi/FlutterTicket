import 'package:flutter/material.dart';
import 'package:easycodestek/gelenTalepModel.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

import 'gelenTalepDetayModel.dart';
import 'gelenTalepDetay_page.dart';

void main() {
  runApp(MyApp());
}

int gid = 1;

class GelenTalepDetay extends StatefulWidget {
  final int id;
  final String baslik;
  final String mesaj;
  final String onem;
  final String konu;
  final String kimden;

  GelenTalepDetay({
    Key? key,
    required this.id,
    required this.baslik,
    required this.mesaj,
    required this.onem,
    required this.konu,
    required this.kimden
  }) : super(key: key);
  @override
  _GelenTalepDetayState createState() => _GelenTalepDetayState();
}

class _GelenTalepDetayState extends State<GelenTalepDetay> {
  Future<List<GelenTalepDetayKart>> getGelenTalepDetayKart() async {
    gid = widget.id;
    var response = await http.get(
      Uri.parse(config.getApiUrl() + '/TicketFlow/GetFlowByTicketID?id=$gid'),
    );
    List<GelenTalepDetayKart> personaas = [];

    if (true) {
      List<dynamic> movies = jsonDecode(response.body);

      for (int i = 0; i < movies.length; i++) {
        try {
          personaas.add(GelenTalepDetayKart.fromJson(movies[i]));
        } catch (e) {
          print(e);
        }
      }
    }

    return personaas;
  }

  TextEditingController _responseController = TextEditingController();
  String _filePath = '';
  double _textBoxHeight = 50; // Başlangıç yüksekliği

  void _sendAnswer() async {
    String cevap = _responseController.text.toString();
    var response = await http.post(
      Uri.parse(config.getApiUrl() +
          '/TicketFlow/AddFlow?ticketID=$gid&supporterID=1&answer=$cevap&statuID=1'),
    );

    setState(() {});
  }

  void _openPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yanıt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 250, // Sabit genişlik
                child: TextField(
                  controller: _responseController,
                  maxLines: null, // Birden fazla satıra izin ver
                  decoration: InputDecoration(labelText: 'Yanıtınızı giriniz'),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null) {
                        setState(() {
                          _filePath = result.files.single.path!;
                        });
                      }
                    },
                    child: Text('Dosya Ekle'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _sendAnswer();
                      Navigator.pop(context);
                    },
                    child: Text('Gönder'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Talep Detayı'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double maxWidth = constraints.maxWidth;
            final double maxHeight = constraints.maxHeight;
            final double min = maxHeight*0.05;
            final double cardHeight = maxHeight * 0.8;
            final double cardWidth = maxWidth * 0.8;
            final double lineSize = cardHeight*0.005;
            print(widget.baslik + " " + widget.mesaj);

            return Center(
              child: Column(
                children: [
                  Container(
                    height: 100+min,
                    child:Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0.5),
                      child: Card(
                        color: Colors.white,
                          child: ListTile(
                            title: Text(
                              textAlign: TextAlign.center,
                              'Başlık: ' + widget.baslik,
                              style: TextStyle(

                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle:
                            Column(
                              children: [
                                SizedBox(
                                  width: maxWidth,
                                  height: lineSize+10,
                                ),
                                SizedBox(
                                  width: cardWidth,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        'Mesaj: ' + widget.mesaj + "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec porttitor elit sed justo dictum, et aliquam dui convallis. Nunc non metus orci. Interdum et malesuada fames ac ante ipsum primis in faucibus. Vestibulum bibendum dolor a dui placerat elementum. Nullam faucibus interdum erat condimentum suscipit. Nullam tristique blandit tellus, ut pharetra dui tincidunt ut. Curabitur varius sapien ac aliquam varius.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: lineSize,
                                ),
                                SizedBox(
                                  width: cardWidth,
                                  child: Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    children: [
                                      Text(
                                        'Şube: ' + widget.kimden,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Tarih: ' +
                                            widget.mesaj,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Kimden: ' +
                                            widget.kimden,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        'Konu: ' +
                                            widget.konu,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Önem: ' +
                                            widget.onem,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )


                          )),
                    ),
                  ),
                  SizedBox(
                    width: maxWidth,
                    height: lineSize,
                    child: Container(
                      color: Colors.grey.shade100,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    height: maxHeight  - lineSize - 100-min,
                    child: FutureBuilder<List<GelenTalepDetayKart>>(
                      future: getGelenTalepDetayKart(),
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
                                    title: Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      children: [
                                        Text(
                                          'Cevap: ' + item.answer.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    subtitle: Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                        children: [
                                          Text(
                                            'Cevaplayan: ' +
                                                item.supporterName.toString() +
                                                " " +
                                                item.supporterLastName.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            'Mesaj Tarihi: ' +
                                                item.actionDate.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            'Durumu: ' + item.statu.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ]),
                                    trailing: Wrap(
                                      spacing: 8.0,
                                      children: [],
                                    ),
                                  )),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              )
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
      title: 'Gelen Talepler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
