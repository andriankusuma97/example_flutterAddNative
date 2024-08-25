import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttersegment/component/card-payment.dart';
import 'package:fluttersegment/component/pie-chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../contex/chart-data.dart';


List<Map<String, String>> data = [
  {
    "title": "Shopping",
    "label": "Belanja kebutuhan Kost",
  },
  {"title": "Transfer", "label": "Bayar sewa Parkir"},
  {"title": "Markatable", "label": "Furniture Rumah"},
  {"title": "Sport", "label": "Bola Basket"},
];

List<Map<String, String>> dataIcon = [
  {
    "icons": "assets/icons/ic_common_money_in.png",
  },
  {
    "icons": "assets/icons/ic_common_cc_loan_disbursement.png",
  },
  {
    "icons": "assets/icons/ic_common_cc_refund.png",
  },
  {
    "icons": "assets/icons/ic_common_investasi.png",
  },
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _message = "No message received";
  Map<String, dynamic> _data = {};
  var dataOutGoing = [];
  bool _isLoading = true;
  late List<ChartData> chartData;
  // static const platform = MethodChannel('com.example.nativehost/channel');
  @override
  void initState() {
    super.initState();
    // _receiveMessageFromNative();
    // _setupMethodChannel();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var url = Uri.https('zb5bb2z0-6970.asse.devtunnels.ms', 'getperson');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final dataFetch =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        print("$dataFetch <<<<<<<, ini dari response 200");
        await Future.delayed(Duration(seconds: 3));
        return setState(() {
          _data = dataFetch;
          dataOutGoing = dataFetch["dataOutGoing"];
          chartData = convertDataToChartData(dataFetch["dataOutGoing"]);
          _isLoading = false;
        });
      } else {
        print("errro");
        throw Exception("Failed to get data: ${response.statusCode}");
      }
    } catch (e) {
      print("errro");
      throw Exception("Failed to get data: ${e}");
    }
  }

  Future<void> _refreshData() async {
    await fetchData();
  }

  List<ChartData> convertDataToChartData(List<dynamic> data) {
    return data.map((item) {
      return ChartData(
        item['title'],
        item['percentage'].toDouble(),
        getColorForTitle(item['title']),
      );
    }).toList();
  }

  Color getColorForTitle(String title) {
    switch (title) {
      case 'Shopping':
        return Colors.blue;
      case 'Transfer':
        return Colors.green;
      case 'Markatable':
        return Colors.red;
      case 'Sport':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
  // Future<void> _receiveMessageFromNative() async {
  //   String message;
  //   try {
  //     message = await platform.invokeMethod('getMessage');
  //     setState(() {
  //       message = message;
  //     });
  //     print("Received message: $message");
  //   } on PlatformException catch (e) {
  //     message = "Failed to receive message: '${e.message}'.";
  //   }

  //   setState(() {
  //     _message = message;
  //   });
  // }

  // void _setupMethodChannel() {
  //   platform.setMethodCallHandler((MethodCall call) async {
  //     if (call.method == "sendInput") {
  //       print("${call.arguments} <<<<, ini dari flutter");
  //       setState(() {
  //         _message = "${call.arguments}";
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cash Flow",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF3AA8A0),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      color: Color(0xFF3AA8A0),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "<",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Period",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "1 Nov 2023 - 30 Nov 2023",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(">",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white))
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.only(top: 20),
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            child: Text("All IDR accounts"),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: double.maxFinite,
                      margin: EdgeInsets.only(top: 300),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                                // _message,
                                '${_data["person"]}',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            child: Text("Summary",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 220,
                            width: 350,
                            child: PieChart(chartData: chartData),
                          ),
                          ListView.separated(
                            padding: EdgeInsets.all(10),
                            itemCount: dataOutGoing.length,
                            shrinkWrap: true, // Tambahkan ini
                            physics:
                                NeverScrollableScrollPhysics(), // Tambahkan ini
                            itemBuilder: (context, index) {
                              final item = dataOutGoing[index];
                              // final iconItem = dataIcon[index];
                              return CardPayment(
                                titleLabel: "${item["title"]}",
                                contentLabel: "${item["label"]}",
                                imageCostume: "${item["icon"]}",
                                percentage: item["percentage"],
                                totalTransaction: "10",
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/detail',
                                    arguments: "${item["title"]}",
                                  );
                                },
                              );
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.fromLTRB(24, 140, 24, 0),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFF02C794),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                              ),
                                              SizedBox(width: 4),
                                              Text("Incoming",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                          Text(
                                            "Rp220.000.000",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 20,
                                    decoration:
                                        BoxDecoration(color: Colors.grey),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFD65C5C),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                              ),
                                              SizedBox(width: 4),
                                              Text("Outgoing",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                          Text("Rp220.000.000",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16),
                              child: Column(
                                children: [
                                  Text("Cash balance",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400)),
                                  Text("+Rp20.000.000",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF02C794),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
