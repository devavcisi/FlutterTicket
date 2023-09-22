import 'package:flutter/material.dart';
import 'package:easycodestek/gelenTalepModel.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

import 'goruntuleyenlerModel.dart';

void main() {
  runApp(MyApp());
}

int gid = 1;

class Goruntuleyenler extends StatefulWidget {
  final int id;

  Goruntuleyenler({
    Key? key,
    required this.id,
  }) : super(key: key);
  @override
  _GoruntuleyenlerState createState() => _GoruntuleyenlerState();
}

class _GoruntuleyenlerState extends State<Goruntuleyenler> {
  Future<List<GoruntuleyenKart>> getGoruntuleyenler() async {
    gid = widget.id;
    print(gid);
    var response = await http.get(
      Uri.parse(config.getApiUrl() + '/Goruntuleyenler/GetGoruntuleyenlerByTicketID?ticketID=${widget.id}'),
    );
    List<GoruntuleyenKart> personaas = [];
    if (true) {
      List<dynamic> movies = jsonDecode(response.body);

      for (int i = 0; i < movies.length; i++) {
        try {
          personaas.add(GoruntuleyenKart.fromJson(movies[i]));
        } catch (e) {
          print(e);
        }
      }
    }

    return personaas;
  }

  TextEditingController _responseController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gelen Talepler'),
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

            return Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: cardWidth,
                      height: maxHeight  - lineSize - 100-min,
                      child: FutureBuilder<List<GoruntuleyenKart>>(
                        future: getGoruntuleyenler(),
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
                                      subtitle: Wrap(
                                        alignment: WrapAlignment.spaceAround,
                                        crossAxisAlignment: WrapCrossAlignment.start,
                                        children: [
                                          Text(
                                            'Görüntüleyen: ' + item.userName + " " + item.userLastname,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            'Görüntüleme Tarihi: ' + item.tarih.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
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
