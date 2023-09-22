import 'package:easycodestek/banaAtananModel.dart';
import 'package:flutter/material.dart';
import 'package:easycodestek/gelenTalepModel.dart';
import 'atamaYap_page.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'geleTalepDetayYanitli_page.dart';
import 'gelenTalepDetay_page.dart';


void main() {
  runApp(MyApp());
}
late int gelenId;
late int ownerID;


class yardimStatu {
  final int ticketID;
  final int supporterID;
  final String? answer;
  final int statuID;
  final String? attachment;
  final String? fileName;
  final String? type;

  yardimStatu({
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

        print(jsonData); // JSON verisini yazdır

    return jsonData;
  }

}
class AtananlarPage extends StatefulWidget {

  final String gelenbody;

  AtananlarPage({required this.gelenbody});

  @override
  _AtananlarPageState createState() => _AtananlarPageState();
}



class _AtananlarPageState extends State<AtananlarPage> {
  Future<List<BanaAtananKart>> getozelgelenlerbilgi() async {

    gelenId = jsonDecode(widget.gelenbody)['id'];

    print("Gelen id"+gelenId.toString());

    var response = await http.get(
      Uri.parse(config.getApiUrl()+ '/Ticket/GetTicketsByAssignedIDWithoutClosed?id=$gelenId'),
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

  void yardimiste(int ticketId) async {


    var response = await http.put(
      Uri.parse(config.getApiUrl() +
          '/Helping/SetTicketNeedHelpByTicketID?ticketID=$ticketId&needHelp=true'),
    );
    print(response.statusCode);
    setState(() {
      // setState işleminizi gerçekleştirin
    });
  }
  Future<void>  yardimIsteStatu(yardimStatu flow) async {
    final apiUrl = Uri.parse(config.getApiUrl() + '/TicketFlow/AddFlow2');

    final  response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(flow.toJson()),
    );

    if (response.statusCode == 200) {
      print('Veri başarıyla gönderildi: ${response.body}');
    } else {
      print('Veri gönderme başarısız oldu. Hata kodu: ${response.statusCode}');
    }
  }




  void setTamamlandi(int ticketId) async {

    var response = await http.post(
      Uri.parse(config.getApiUrl()+'/TicketFlow/AddFlow?ticketID=$ticketId&supporterID=$gelenId&answer=Ticket Kapatıldı&statuID=5'),
    );
    setState(() {

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bana Atananlar'),
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
                                      print(gelenId);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GelenTalepDetayYanitli(id:item.id,uid: gelenId,baslik: item.subject,mesaj: item.message, onem: item.priorityName.toString(), konu: item.categoryName.toString(), kimden: item.ownerID.toString(),),
                                        ),
                                      );
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.orange,
                                    ),
                                    child: Text(
                                      "Yardım İste",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      int uid = gelenId;
                                      int sid=4;
                                      final flow = yardimStatu(
                                        ticketID: item.id,
                                        supporterID: uid,
                                        answer: "",
                                        statuID: sid,
                                        attachment: "",
                                        fileName: "",
                                        type: "",
                                      );
                                      yardimIsteStatu(flow);


                                      yardimiste(item.id);

                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(

                                      primary: Colors.white54,
                                    ),
                                    
                                    child: Text(
                                      "Tamamla",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Emin Misiniz?"),
                                            content: Text("Bu ticket'ı kapatmak istediğinize emin misiniz?"),
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

                                                  setTamamlandi(item.id);

                                                  Navigator.of(context).pop(); // İletişim kutusunu kapat
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
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
      title: 'Bana Atananlar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
