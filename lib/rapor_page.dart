import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:easycodestek/atamalar_page.dart';
import 'package:easycodestek/services.dart';
import 'package:flutter/material.dart';
import 'package:easycodestek/gelenTalepModel.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easycodestek/loginModel.dart';
import 'gelenTalepDetay_page.dart';
import 'package:date_field/date_field.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

String isim = '';

int yanitsayisi = 1;
int newyanitsayisi = 0;

int yardimisteme = 0;
int newyardimisteme = 1;

late int tamamlanan = 1;
int newtamamlandi = 0;

late int banaata;
int newBanaatanan = 0;

int atanan = 0;

int yardimetme = 0;
int newyardimetme = 0;

DateTime ortalamaacilis = DateTime.now();
int kisiId = 1;
String bastar = "2022-01-01";
String bittar = "2024-01-01";
DateTime Gbittar = DateTime.now();
DateTime Gbastar = DateTime.now().subtract(Duration(days: 1));
String ss = "";
double maxWidth = 500;
double maxHeight = 500;

String? _selectedItemValue = '1';
String? _selectedItemLabel = 'Kader';

final List<Map<String, String>> dropdownItems = [
  {'value': '1', 'label': 'IBAY'},
  {'value': '2', 'label': 'IBAY2'},
];

List<ChartDataMultiBar> chartDataMultiBar = [
  ChartDataMultiBar('Yanıtlanan', [4, 0, 7, 6, 7, 8, 8, 8, 5, 4]),
  ChartDataMultiBar('Yardım İsteme', [4, 5, 7, 8, 4, 3, 2, 3, 4, 6]),
  ChartDataMultiBar('Tamamlanan', [4, 5, 7, 8, 6, 3, 2, 4, 6, 3]),
  ChartDataMultiBar('Atama Alma', [4, 5, 7, 9, 6, 5, 8, 1, 6, 8]),
  ChartDataMultiBar('Yardım Etme', [4, 7, 8, 9, 4, 5, 3, 7, 3, 7]),
];

List<ChartData> chartData = [
  ChartData("Yanıtlanan", yanitsayisi.toDouble()),
  ChartData("Yardım İsteme", yardimisteme.toDouble()),
  ChartData("Tamamlanan", tamamlanan.toDouble()),
  ChartData("Atama Alma", atanan.toDouble()),
  ChartData("Yardım Etme", yardimetme.toDouble()),
];

class RaporPage extends StatefulWidget {
  @override
  _RaporPageState createState() => _RaporPageState();
}

class _RaporPageState extends State<RaporPage> {
  String dropdownValue = 'Seçenek 1';
  DateTime selectedDateBaslangic = DateTime.now();
  DateTime selectedDateBitis = DateTime.now();

  @override
  void initState() {
   drop();
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
        print(tickets[i]['id']);

        dropdownItems.add({
          'value': tickets[i]['id'].toString(),
          'label': tickets[i]['name']
        });
        setState(() {});
      }
    }

    return personaas;
  }

  bool isIstatistikVisible = false;

  void toggleIstatistikVisibility() {
    setState(() {
      isIstatistikVisible = !isIstatistikVisible;
    });
  }

//deneme
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    void updateChartData() async {
      chartData = [
        ChartData("Yanıtlanan", yanitsayisi.toDouble()),
        ChartData("Yardım İsteme", yardimisteme.toDouble()),
        ChartData("Tamamlanan", tamamlanan.toDouble()),
        ChartData("Atama Alma", atanan.toDouble()),
        ChartData("Yardım Etme", yardimetme.toDouble()),
      ];

      setState(() {
        bar();
      });
    }

    List<num?> cevapSayilari = [];
    List<num?> yardimistemeSayilari = [];
    List<num?> tamamlananSayilari = [];
    List<num?> banaatananSayilari = [];
    List<num?> yardimEtmeSayilari = [];

    Future<void> multiBarVeriler() async {
      for (int i = 0; i < dropdownItems.length; i++) {
        String isim = dropdownItems[i]['label'].toString();
        double cevapSayisi =
            double.parse(await getCevapSayisi(i + 1, Gbastar, Gbittar));
        double yardimIstemeSayisi =
            double.parse(await getYardimIstemeSayisi(i + 1, Gbastar, Gbittar));
        double tamamlanmaSayisi =
            double.parse(await getTamamlandiCount(i + 1, Gbastar, Gbittar));
        double banaatananSayisi =
            double.parse(await getToplamAtanmisCount(i + 1, Gbastar, Gbittar));
        double yardimEtmeSayisi =
            double.parse(await getYardimSayisi(i + 1, Gbastar, Gbittar));

        cevapSayilari.add(cevapSayisi);
        yardimistemeSayilari.add(yardimIstemeSayisi);
        tamamlananSayilari.add(tamamlanmaSayisi);
        banaatananSayilari.add(banaatananSayisi);
        yardimEtmeSayilari.add(yardimEtmeSayisi);
      }
      chartDataMultiBar = [
        ChartDataMultiBar('Yanıtlanan', cevapSayilari),
        ChartDataMultiBar("Yardım İsteme", yardimistemeSayilari),
        ChartDataMultiBar("Tamamlanan", tamamlananSayilari),
        ChartDataMultiBar("Atama Alma", banaatananSayilari),
        ChartDataMultiBar("Yardım Etme", yardimEtmeSayilari),
      ];
    }

    Future<void> getAndSetYanitSayisi() async {
      String cevapSayisiData = await getCevapSayisi(kisiId, Gbastar, Gbittar);
      int yeniYanitSayisi = int.parse(cevapSayisiData);
      setState(() {
        yanitsayisi = yeniYanitSayisi;
      });
    }

    Future<void> getAndSetYardimIstemeSayisi() async {
      String yardimIstemeSayisiData =
          await getYardimIstemeSayisi(kisiId, Gbastar, Gbittar);
      int yeniYardimIstemeSayisi = int.parse(yardimIstemeSayisiData);
      setState(() {
        yardimisteme = yeniYardimIstemeSayisi;
      });
    }

    Future<void> getAndSetTamamlananSayisi() async {
      String tamamlananSayisiData =
          await getTamamlandiCount(kisiId, Gbastar, Gbittar);
      int yenitamamlananSayisi = int.parse(tamamlananSayisiData);
      setState(() {
        tamamlanan = yenitamamlananSayisi;
      });
    }

    Future<void> getAndSetAtanmaSayisi() async {
      String atanmaSayisiData =
          await getToplamAtanmisCount(kisiId, Gbastar, Gbittar);
      int yeniAtanmisSayisi = int.parse(atanmaSayisiData);
      setState(() {
        atanan = yeniAtanmisSayisi;
      });
    }

    Future<void> getAndSetYardimEtmeSayisi() async {
      String yardimEtmeSayisiData =
          await getYardimSayisi(kisiId, Gbastar, Gbittar);
      int yeniYardimSayisi = int.parse(yardimEtmeSayisiData);
      setState(() {
        yardimetme = yeniYardimSayisi;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('RAPORLAR'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double maxWidthLocal = constraints.maxWidth - 100;
            final double maxHeightLocal = constraints.maxHeight - 200;
            maxHeight = maxHeightLocal;
            maxHeight = maxHeightLocal;
            final double cardHeight = maxHeight / 3;
            final double cardWidth = maxWidth / 3;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Center(
                      child: Card(
                        child: Container(
                          //  width: min(maxWidth + 80, 600), // Genişlik, 600'den büyük değilse maxWidth + 80 olacak
                          height: maxHeight / 6,

                          padding: EdgeInsets.all(8.0),
                          child: Wrap(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: maxWidth * 0.20,
                                    height: maxHeight * 0.20,
                                    child: DateTimeFormField(
                                      initialValue: DateTime.now(),
                                      decoration: const InputDecoration(
                                        hintStyle:
                                            TextStyle(color: Colors.black45),
                                        errorStyle:
                                            TextStyle(color: Colors.redAccent),
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
                                        print('başlangıç Tarihi    ' +
                                            value.toString());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: maxWidth * 0.20,
                                    height: maxHeight * 0.20,
                                    child: DateTimeFormField(
                                      initialValue: DateTime.now(),
                                      decoration: const InputDecoration(
                                        hintStyle:
                                            TextStyle(color: Colors.black45),
                                        errorStyle:
                                            TextStyle(color: Colors.redAccent),
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
                                        print('bitiş Tarihi    ' +
                                            value.toString());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 6),
                              Column(
                                children: [
                                  Text(
                                    'Kişi Seç',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  DropdownButton<String>(
                                    value: _selectedItemValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedItemValue = newValue;

                                        _selectedItemLabel =
                                            dropdownItems.firstWhere((item) =>
                                                item['value'] ==
                                                newValue)['label'];
                                      });
                                    },
                                    items: dropdownItems
                                        .map<DropdownMenuItem<String>>(
                                            (Map<String, String> item) {
                                      return DropdownMenuItem<String>(
                                        value: item['value']!,
                                        child: Text(item['label']!),
                                      );
                                    }).toList(),
                                    hint: Text("Kişi Seç"),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      if (Gbastar.isAfter(Gbittar)) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('HATA'),
                                              content: Text(
                                                  'Başlangıç Tarihi Bitiş Tarihinden Sonra Olamaz.'),
                                            );
                                          },
                                        );
                                      } else {
                                        setState(() async {
                                          isim = _selectedItemLabel.toString();
                                          kisiId = int.parse(
                                              _selectedItemValue.toString());

                                          await getAndSetYanitSayisi();
                                          await getAndSetYardimIstemeSayisi();
                                          await getAndSetTamamlananSayisi();
                                          await getAndSetAtanmaSayisi();
                                          await getAndSetYardimEtmeSayisi();
                                          await multiBarVeriler();
                                          updateChartData();
                                          istatistikleriGetir();

                                          print(yanitsayisi);
                                          print("Seçilen Kişi:  $ss");
                                          print("Başlangıç Tarihi:  $Gbastar");
                                          print("Bitiş Tarihi:  $Gbittar");
                                        });
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Card(
                      color: Colors.white30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Kullanıcı Adı : ' + isim,
                            style: TextStyle(
                                fontSize: maxHeight / 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: maxWidth * 4,
                        height: maxHeight,
                        child: (MediaQuery.of(context).size.width < 700)
                            ? SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    istatistikleriGetir(),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            bar(),
                                            Positioned(
                                              left: 30, // Sol kenardan uzaklık
                                              top: 30, // Üst kenardan uzaklık
                                              child: Text(
                                                'Kişisel İstatistik Grafiği',
                                                style: TextStyle(
                                                  fontSize: maxWidth / 40,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: maxHeight / 30,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            //buildDonutChart(),
                                            // buildMultiBarChart(data),
                                            barMulti(chartDataMultiBar),
                                            Positioned(
                                              left: 30, // Sol kenardan uzaklık
                                              top: 30, // Üst kenardan uzaklık
                                              child: Text(
                                                'İstatistik Grafiği',
                                                style: TextStyle(
                                                  fontSize: maxWidth / 40,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    isIstatistikVisible
                                        ? Expanded(
                                            child: istatistikleriGetir(),
                                          )
                                        : Container(),
                                    // İstatistikleri buraya ekleyin veya boş bir Container ekleyin
                                    IconButton(
                                      onPressed: () {
                                        toggleIstatistikVisibility();
                                      },
                                      icon: Icon(Icons.arrow_right_rounded),
                                    ),
                                    Expanded(
                                      flex: 4, // Sağ tarafı 4 parçaya böl
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height: maxHeight,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Stack(
                                                        children: [
                                                          // buildDonutChart(),
                                                          // barChart(),
                                                          bar(),

                                                          Positioned(
                                                            left: 50,
                                                            top: 30,
                                                            child: Text(
                                                              'Kişisel İstatistik Grafiği',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    maxWidth /
                                                                        40,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Stack(
                                                        children: [
                                                          //buildPieChart(),
                                                          // buildLineChart(lineData),
                                                          // lineChart(),

                                                          // buildMultiBarChart(data),
                                                          barMulti(
                                                              chartDataMultiBar),
                                                          Positioned(
                                                            left: 50,
                                                            top: 30,
                                                            child: Text(
                                                              'İstatistik Grafiği',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    maxWidth /
                                                                        40,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                  ])
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget istatistikleriGetir() {
  return Column(
    children: [
      Container(
        height: maxHeight / 7,
        width: maxWidth + 80,
        child: Card(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Text(
                  'Yanıt Sayısı',
                  style: TextStyle(
                      fontSize: maxHeight / 20, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<String>(
                    future: getCevapSayisi(kisiId, Gbastar, Gbittar),
                    builder: (context, snapshots) {
                      /* yanitsayisi = int.parse(snapshots.data!);
                      newyanitsayisi = yanitsayisi;*/
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshots.hasData) {
                        return Text(
                          snapshots.data.toString(),
                          style: TextStyle(
                              fontSize: maxHeight / 20,
                              fontWeight: FontWeight.bold),
                        );
                      } else {
                        return Text('Veri yok');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        height: maxHeight / 7,
        width: maxWidth + 80,
        child: Card(
          color: Colors.white30,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Yardım İsteme',
                  style: TextStyle(
                      fontSize: maxHeight / 20, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<String>(
                    future: getYardimIstemeSayisi(kisiId, Gbastar, Gbittar),
                    builder: (context, snapshots) {
                      /*   yardimisteme = int.parse(snapshots.data!);
                      newyardimisteme = yardimisteme;*/
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshots.hasData) {
                        return Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            snapshots.data.toString(),
                            style: TextStyle(
                              fontSize: maxHeight / 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return Text('Veri yok');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        height: maxHeight / 7,
        width: maxWidth + 80,
        child: Card(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Tamamlanan',
                  style: TextStyle(
                      fontSize: maxHeight / 20, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<String>(
                    future: getTamamlandiCount(kisiId, Gbastar, Gbittar),
                    builder: (context, snapshots) {
                      /*  tamamlanan = int.parse(snapshots.data!);
                      newtamamlandi = tamamlanan;*/
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshots.hasData) {
                        return Text(
                          snapshots.data.toString(),
                          style: TextStyle(
                              fontSize: maxHeight / 20,
                              fontWeight: FontWeight.bold),
                        );
                      } else {
                        return Text('Veri yok');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      Container(
        height: maxHeight / 7,
        width: maxWidth + 80,
        child: Card(
          color: Colors.white30,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Atama Alma',
                  style: TextStyle(
                      fontSize: maxHeight / 20, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<String>(
                      future: getToplamAtanmisCount(kisiId, Gbastar, Gbittar),
                      builder: (context, snapshots) {
                        /* atanan = int.parse(snapshots.data!);
                        newBanaatanan = atanan;*/

                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshots.hasData) {
                          return Text(
                            snapshots.data.toString(),
                            style: TextStyle(
                                fontSize: maxHeight / 20,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text('Veri yok');
                        }
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
      Container(
        height: maxHeight / 7,
        width: maxWidth + 80,
        child: Card(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Yardım Etme Sayısı',
                  style: TextStyle(
                      fontSize: maxHeight / 25, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<String>(
                    future: getYardimSayisi(kisiId, Gbastar, Gbittar),
                    builder: (context, snapshots) {
                      /*  yardimetme = int.parse(snapshots.data!);
                      newyardimetme = yardimetme;*/
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshots.hasData) {
                        return Text(
                          snapshots.data.toString(),
                          style: TextStyle(
                              fontSize: maxHeight / 20,
                              fontWeight: FontWeight.bold),
                        );
                      } else {
                        return Text('Veri yok');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        height: maxHeight / 7,
        width: maxWidth + 80,
        child: Card(
          color: Colors.white30,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Ortalama Yanıt Süresi',
                  style: TextStyle(
                      fontSize: maxHeight / 30, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<String>(
                    future: getMudaheleSuresiOrt(kisiId, Gbastar, Gbittar),
                    builder: (context, snapshots) {
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshots.hasData) {
                        return Text(
                          snapshots.data.toString() + " Dakika",
                          style: TextStyle(
                              fontSize: maxHeight / 30,
                              fontWeight: FontWeight.bold),
                        );
                      } else {
                        return Text('Veri yok');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class ChartData {
  final String? x;
  final double? y1;

  ChartData(this.x, this.y1);
}

Widget bar() {
  return Container(
    child: SfCartesianChart(
      primaryXAxis: CategoryAxis(), // X ekseni için CategoryAxis kullanılıyor
      series: <ChartSeries<ChartData, String>>[
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y1,
          width: 0.8,
          spacing: 0.2,
          color: Colors.orangeAccent,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.middle,
            textStyle: TextStyle(fontSize: 15),
          ),
        )
      ],
    ),
  );
}




class ChartDataMultiBar {
  final String? x;
  final List<num?> yList;

  ChartDataMultiBar(this.x, this.yList);
}


List<String> dropdownLabels = dropdownItems.map((item) => item['label']!).toList();
Widget barMulti(List<ChartDataMultiBar> chartDataList) {

  List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.orange];


  List<ColumnSeries<ChartDataMultiBar, String>> seriesList = [];


  for (int i = 0; i < chartDataList[0].yList.length; i++) {
    seriesList.add(
      ColumnSeries<ChartDataMultiBar, String>(
        dataSource: chartDataList,
        xValueMapper: (ChartDataMultiBar data, _) => data.x!,
        yValueMapper: (ChartDataMultiBar data, _) {
          if (i < data.yList.length) {
            return data.yList[i] ?? 0;
          } else {
            return 0;
          }
        },
        width: 0.3,
        name: 'Çubuk ${i + 1}',
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.middle,
          textStyle: TextStyle(fontSize: 15),
        ),

        color: colors[i % colors.length],
      ),
    );
  }


  Widget legendRow = Row(
    children: List.generate(dropdownItems.length, (index) {
      return Row(
        children: [
          IconButton(onPressed: (){}, icon: Icon(Icons.person, color: colors[index]))
          ,
          Text(dropdownItems[index]['label'].toString()),
        ],
      );
    }),
  );

  return Container(
    child: Column(
      children: [
        Expanded(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: seriesList,
          ),
        ),
        legendRow,
      ],
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gelen Talepler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RaporPage(),
    );
  }
}
