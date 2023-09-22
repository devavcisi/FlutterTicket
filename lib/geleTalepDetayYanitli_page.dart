import 'dart:io';
import 'dart:typed_data';

import 'package:easycodestek/attachmentsModel.dart';
import 'package:easycodestek/flowAttachmentsModel.dart';
import 'package:flutter/material.dart';
import 'package:easycodestek/gelenTalepModel.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:path/path.dart' as path;

import 'gelenTalepDetayModel.dart';
import 'package:image/image.dart' as img;

import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:easy_folder_picker/FolderPicker.dart';


void main() {
  runApp(MyApp());
}

int gid = 1;
int gelenUidYanitda = 1;

int? flowId;

String attachment = '';
String dosyaTur = '';
String dosyaUzantisi = '';

class GelenTalepDetayYanitli extends StatefulWidget {
  final int id;
  final int uid;
  final String baslik;
  final String mesaj;
  final String onem;
  final String konu;
  final String kimden;

  GelenTalepDetayYanitli(
      {Key? key,
      required this.id,
      required this.uid,
      required this.baslik,
      required this.mesaj,
      required this.onem,
      required this.konu,
      required this.kimden})
      : super(key: key);
  @override
  _GelenTalepDetayYanitliState createState() => _GelenTalepDetayYanitliState();
}

class _GelenTalepDetayYanitliState extends State<GelenTalepDetayYanitli> {
  Future<List<GelenTalepDetayKart>> getGelenTalepDetayKart() async {
    gid = widget.id;
    gelenUidYanitda = widget.uid;
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

  Future<List<GelenTalepDetayAttachmentKart>>
      getGelenTalepDetayAttachmentKart() async {
    gid = widget.id;
    var response = await http.get(
      Uri.parse(
          config.getApiUrl() + '/Attachment/GetAttachmentsByTicketID?id=$gid'),
    );

    List<GelenTalepDetayAttachmentKart> attachments = [];

    if (response.statusCode == 200) {
      List<dynamic> movies = jsonDecode(response.body);

      for (int i = 0; i < movies.length; i++) {
        try {
          attachments.add(GelenTalepDetayAttachmentKart.fromJson(movies[i]));
          // listeTicket.add('Ek.'+movies[i]['type']);
          //print(movies[i]);
        } catch (e) {
          print(e);
        }
      }
    }

    // attachmentDecode(attachment, dosyaTur);

    return attachments;
  }

  Future<List<GelenTalepDetayFlowAttachmentKart>>
      getGelenTalepDetayFlowAttachmentKart(int w) async {
    print(w);
    var response = await http.get(
      Uri.parse(
          config.getApiUrl() + '/TicketFlow/GetFlowAttachmentsByID?id=$w'),
    );

    List<GelenTalepDetayFlowAttachmentKart> flow = [];

    if (response.statusCode == 200) {
      List<dynamic> flowMovies = jsonDecode(response.body);

      for (int i = 0; i < flowMovies.length; i++) {
        try {
          flow.add(GelenTalepDetayFlowAttachmentKart.fromJson(flowMovies[i]));
          // listeTicket.add('Ek.'+movies[i]['type']);
          //print(flowMovies[i]);
        } catch (e) {
          print(e);
        }
      }
    }

    // attachmentDecode(attachment, dosyaTur);

    return flow;
    print(flow);
  }

  Future<void> sendDataFLow(flowAttachment flow) async {
    final apiUrl = Uri.parse(config.getApiUrl() + '/TicketFlow/AddFlow2');

    final response = await http.post(
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
    setState(() {
      
    });
  }

  void attachmentDecode(
      String attachment, String ad, String type, String path) {
    try {
      if (['png', 'jpg', 'jpeg', 'bmp', 'tiff', 'webp', '.jpg', '.JPG']
          .contains(type)) {
        final originalWordBytes = hexToBytes(attachment);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: InteractiveViewer(
                boundaryMargin:
                    EdgeInsets.all(20), // İçeriği sınırlarla çevreleyin
                minScale: 0.5, // Min yakınlaştırma düzeyi
                maxScale: 3.0, // Max yakınlaştırma düzeyi
                child: SingleChildScrollView(
                  child: Image.memory(Uint8List.fromList(originalWordBytes)),
                ),
              ),
            );
          },
        );
      } else {
        final originalWordBytes = hexToBytes(attachment);

        final tempFilePath = path.toString() +'/'+ ad + '.' + type;
        print(tempFilePath);
        File(tempFilePath)
            .writeAsBytesSync(Uint8List.fromList(originalWordBytes));
        showNotificationBanner('Dosya İndirildi');
        print('Dosya işlendi: $tempFilePath');
      }
    } catch (e) {
      showNotificationBanner('Dosya İndirme Hatası!');
      print('Dosya işleme hatası: $e');
    }
  }

  String attachmentEncode(String filePath) {
    String hex = '';

    try {
      print(filePath);

      // Dosyanın bir resim olup olmadığını kontrol etmek için dosya uzantısını al
      final fileExtension = filePath.split('.').last.toLowerCase();
      if (['png', 'jpg', 'jpeg', 'bmp', 'tiff', 'webp']
          .contains(fileExtension)) {
        final File imageFile = File(filePath);
        final img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;

        // Resmi sıkıştır
        final img.Image compressedImage = img.copyResize(
          image,
          width: 1200,
          height: 1000,
        );

        final List<int> bytes = img.encodeJpg(compressedImage);
        hex = bytesToHex(bytes);
      } else {
        final File attachmentFile = File(filePath);
        final List<int> bytes = attachmentFile.readAsBytesSync();
        hex = bytesToHex(bytes);
      }

      print('Hexadecimal Kodu: $hex');
    } catch (e) {
      print('Dönüştürme hatası: $e');
    }
    return hex;
  }

  String bytesToHex(List<int> bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  }

  Uint8List convertToVarBinary(String text) {
    // Veriyi VARBINARY formatına çevirme işlemi
    Uint8List varBinaryData = Uint8List.fromList(text.codeUnits);
    return varBinaryData;
  }

  Uint8List hexToBytes(String hex) {
    return Uint8List.fromList(List<int>.generate(hex.length ~/ 2,
        (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16)));
  }

  TextEditingController _responseController = TextEditingController();
  String _filePath = '';
  String _fileName = '';
  String? _downloadPath = '';
  double _textBoxHeight = 50; // Başlangıç yüksekliği

  Future<void> makePostRequests(List<String> items) async {
    for (var item in items) {
      String uzanti = path.extension(item);
      try {
        var response = await http.post(
          Uri.parse(config.getApiUrl() +
              '/werTicketFlow/AddFlow?ticketID=$gid&supporterID=$gelenUidYanitda&answer=$_responseController&statuID=3&attachment=$attachmentEncode(item)&type=$uzanti'),
        );
        if (response.statusCode == 200) {
          // Başarılı yanıtı işleyin
          print('Başarılı POST İsteği');
        } else {
          // Hata durumu
          print('POST İsteği Hatası: ${response.statusCode}');
        }
      } catch (e) {
        // Hata durumu
        print('POST İsteği Sırasında Hata: $e');
      }
    }
  }

  Future<String?> sFolder() async {
    String? result = await FilePicker.platform.getDirectoryPath();

   String newResult = result!.replaceAll('\\', '/');
    print(newResult);
    _downloadPath!=newResult;
  }



  /*String? _selectFolder(BuildContext context) {
    String result =  FilePicker.platform.getDirectoryPath().toString();

    if (result != null) {
      print(result);
      return result;
    } else {
      return null;
    }
  }*/

  List<String> liste = [];
  void _openPopup() {
    liste.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                      decoration:
                          InputDecoration(labelText: 'Yanıtınızı giriniz'),

                    ),
                  ),

                  Column(
                    children: liste.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final String item = entry.value;

                      return Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {

                                  setState(() {
                                    liste.removeAt(index); // Öğeyi listeden sil
                                  });
                                },
                                icon: Icon(Icons.delete_forever_sharp, color: Colors.red,),

                              ),
                              SizedBox(width:10,),
                              Text(item),
                            ],
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowMultiple: true, // Dosya türünü belirtiyoruz
                            allowedExtensions: [
                              'jpg',
                              'jpeg',
                              'png',
                              'bmp',
                              'tiff',
                              'webp',
                              'txt',
                              'rtf',
                              'xlsx',
                              'xls',
                              'Xlsm',
                              'xlsb',
                              'docx',
                              'doc',
                              'pdf',
                            ], // İzin verilen dosya uzantıları
                          );
                          if (result != null) {
                            setState(() {
                              for (var file in result.files) {
                                liste.add(file.name);
                              }
                              _filePath = result.files.single.path!;
                              _fileName = result.files.single.name;
                              //liste.add(_filePath);
                              // dosyaUzantisi = path.extension(_fileName);
                            });
                          }
                        },
                        child: Text('Dosya Ekle'),
                      ),
                      ElevatedButton(
                        onPressed: () {

                          //_sendAnswer();

                          String cevap1 = _responseController.text;
                          if(liste.length == 0)
                            {
                              final flow = flowAttachment(
                              ticketID: gid,
                              supporterID: gelenUidYanitda,
                              answer: cevap1,
                              statuID: 3,
                              attachment: null,
                              fileName: null,
                              type: null,
                            );
                              sendDataFLow(flow);}
                          else{
                            final flow = flowAttachment(
                            ticketID: gid,
                            supporterID: gelenUidYanitda,
                            answer: cevap1,
                            statuID: 3,
                            attachment: attachmentEncode(liste[0]).toString(),
                            fileName: _fileName?.split('.').first,
                            type: path
                                .extension(_filePath)
                                .toLowerCase()
                                .substring(1),
                          );
                            sendDataFLow(flow);
                          }


                           _responseController.clear();
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
      },
    );
  }

  //List<String> listeFlow = [];
  /*void _openPopupFlow(int w) async {

    // Önce verileri alalım
    List<GelenTalepDetayFlowAttachmentKart> flowAttachment = await getGelenTalepDetayFlowAttachmentKart(w);
    print(flowAttachment);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ticket Ekleri'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 250, // Sabit genişlik
                child: Column(
                  children: [],
                ),
              ),
              Column(
                children: flowAttachment.map((item) {
                  return ElevatedButton(
                    onPressed: () {
                      // Burada yapmak istediğiniz işlemi gerçekleştirebilirsiniz.
                    },
                    child: Text(item.fileName +'.'+ item.type), // Örnek: Ek. dosya tipi
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Kapat'),
              ),
            ],
          ),
        );
      },
    );

  }*/
  BuildContext? popupContext;
  void _openPopupFlow(int w) {
    showDialog(
      context: context,

      builder: (BuildContext context) {
        popupContext=context;
        return FutureBuilder<List<GelenTalepDetayFlowAttachmentKart>>(
          future: getGelenTalepDetayFlowAttachmentKart(w),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Veri yüklenirken yükleniyor göstergesi
              return Dialog(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Veri yükleniyor...'),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              // Hata durumunda hata mesajını göster
              return AlertDialog(
                title: Text('Hata'),
                content:
                    Text('Veri yüklenirken hata oluştu: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Veri yoksa veya boşsa bir mesaj göster
              return AlertDialog(
                title: Text('Veri Bulunamadı'),
                content: Text('Veri bulunamadı.'),
              );
            } else {
              // Verileri görüntüle
              List<GelenTalepDetayFlowAttachmentKart> flowAttachment =
                  snapshot.data!;
              return AlertDialog(
                title: Text('Ticket Ekleri'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 250, // Sabit genişlik
                      child: Column(
                        children: [],
                      ),
                    ),
                    Column(
                      children: flowAttachment.map((item) {
                        return ElevatedButton(
                          onPressed: () async {
                             // await   sFolder();
                            if(['png', 'jpg', 'jpeg', 'bmp', 'tiff', 'webp', '.jpg', '.JPG']
                                .contains(item.type)) {
                              attachmentDecode(item.attachment!, item.fileName,
                                  item.type, '');
                            }else {
                              String? result = await FilePicker.platform
                                  .getDirectoryPath();

                              String newResult = result!.replaceAll('\\', '/');
                              print(newResult);

                              attachmentDecode(item.attachment!, item.fileName,
                                  item.type, newResult);
                            }
                          },
                          child: Text(item.fileName + '.' + item.type),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Kapat'),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  List<String> listeTicket = [];
  void _openPopupTicket() async {
    // Önce verileri alalım
    List<GelenTalepDetayAttachmentKart> attachments =
        await getGelenTalepDetayAttachmentKart();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        popupContext=context;
        return FutureBuilder<List<GelenTalepDetayAttachmentKart>>(
          future: getGelenTalepDetayAttachmentKart(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Veri yüklenirken yükleniyor göstergesi
              return AlertDialog(
                title: Text('Ticket Ekleri'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Veri yükleniyor...'),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              // Hata durumunda hata mesajını göster
              return AlertDialog(
                title: Text('Hata'),
                content:
                    Text('Veri yüklenirken hata oluştu: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Veri yoksa veya boşsa bir mesaj göster
              return AlertDialog(
                title: Text('Veri Bulunamadı'),
                content: Text('Veri bulunamadı.'),
              );
            } else {
              // Verileri görüntüle
              List<GelenTalepDetayAttachmentKart> attachments = snapshot.data!;
              return AlertDialog(
                title: Text('Ticket Ekleri'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 250,
                      child: Column(
                        children: [],
                      ),
                    ),
                    Column(
                      children: attachments.map((item) {
                        return ElevatedButton(
                          onPressed: () {
                            attachmentDecode(item.attachment!, 'ek', item.type, _downloadPath!.toString());
                          },
                          child: Text('Ek.' + item.type),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Kapat'),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }


  bool showNotification = false;
  String notificationMessage = "";

  void showNotificationBanner(String aciklama) {
    setState(() {
      showNotification = true;
      notificationMessage=aciklama;

      if (popupContext != null) {
        Navigator.of(popupContext!).pop();
       // popupContext = null;
    }});

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showNotification = false;
      });
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gelen Talepler'),
      ),
      body: Stack(children: [     SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double maxWidth = constraints.maxWidth;
            final double maxHeight = constraints.maxHeight;
            final double cardHeight = maxHeight * 0.8;
            final double cardWidth = maxWidth * 0.8;
            final double lineSize = cardHeight * 0.005;
            final double min = maxHeight * 0.05;

            return Center(
                child: Column(
                  children: [
                    Container(
                      height: 100 + min,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0.5),
                        child: Card(
                            color: Colors.white,
                            child: ListTile(
                                title: Text(
                                  textAlign: TextAlign.center,
                                  'Başlık: ' + widget.baslik,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  children: [
                                    SizedBox(
                                      width: maxWidth,
                                      height: lineSize + 10,
                                    ),
                                    SizedBox(
                                      width: cardWidth,
                                      child: Wrap(
                                        children: [
                                          Text(
                                            'Mesaj: ' +
                                                widget.mesaj ,
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
                                          crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                          children: [
                                            Text(
                                              'Şube: ' + widget.kimden,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Tarih: ' + widget.mesaj,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Kimden: ' + widget.kimden,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              'Konu: ' + widget.konu,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Önem: ' + widget.onem,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Visibility(
                                              visible: true,
                                              child: IconButton(
                                                onPressed: () {

                                                  _openPopupTicket();
                                                },
                                                icon: Icon(Icons.attachment),
                                              ),
                                            ),
                                          ]),
                                    )
                                  ],
                                ))),
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
                      height: maxHeight - lineSize - 100 - min,
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
                              flowId = item.id;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 3.0),
                                child: Card(
                                    child: ListTile(
                                      title: Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                        children: [
                                          Text(
                                            (index+1).toString() +'-)   Cevap: ' + item.answer.toString(),
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
                                                  item.supporterLastName
                                                      .toString(),
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
                                        children: [
                                          Visibility(
                                            visible: item.attachmentID != 0,
                                            child: IconButton(
                                              onPressed: () {
                                                int w = item.attachmentID!;
                                                _openPopupFlow(w);
                                              },
                                              icon: Icon(Icons.attachment),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                            ),
                                            child: Text(
                                              "Yanıtla",
                                              style:
                                              TextStyle(color: Colors.white),
                                            ),
                                            onPressed: () {

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
                    ),


                  ],
                ));

          },

        ),


      ),
        if (showNotification)
          Positioned(
            bottom: 16.0, // Sağ alt köşeden çıkması için bottom ve right değerlerini ayarlayın
            right: 16.0,
            child: Container(
              width: 250.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  notificationMessage,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
      ],)

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
