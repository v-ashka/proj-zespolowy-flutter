import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';
import 'package:http/http.dart' as http;

class DashboardContainer extends StatefulWidget {
  const DashboardContainer({Key? key, required this.data, required this.size }) : super(key: key);

  final Map data;
  final Size size;
  @override
  State<DashboardContainer> createState() => _DashboardContainerState();
}

class _DashboardContainerState extends State<DashboardContainer> {

  // Future<void> gethttp() async{
  //   String url = "parameters-rouge-casio-clients.trycloudflare.com";
  //   Response response = await post(Uri.parse('http://parameters-rouge-casio-clients.trycloudflare.com/Samochod'),
  //       headers: <String, String>{ 'Content-Type': 'application/json; charset=UTF-8',},
  //       body: jsonEncode(<String, String>{
  //     'name': 'Polonez',
  //     'engine': '1.8ohjv',
  //     'production_data': '1989',
  //     }),
  //   );
  //   Map data = jsonDecode(response.body);
  //   print(data);
  // }

  void navigateTo(name){
    switch (name){
      case 'cars':
        var carsData = {
          "Car1": {"name": "polonez", "engine": "1.8hp", "production_date": "1994"},
          "Car2": {"name": "fiat 126p", "engine": "1.3", "production_date": "1980"},
          "Car3": {"name": "opel astra f", "engine": "1.6", "production_date": "2000"}
        };
        // var carsData = {'Usrname':'tom','Password':'pass@123'};
        Navigator.pushReplacementNamed(context, '/product_list', arguments: {
          'cars': carsData,
        });
        break;
      case 'documents':
        var documentsData = {
          "document1": {"name": "Akt chrztu", "desc": "Plik z aktem chrztu", "created_at": "2022-05-26"},
          "document2": {"name": "Umowa najmu", "desc": "Umowa najmu mieszkania przy ulicy..", "created_at": "2020-03-03"},
          "document3": {"name": "Recepta", "desc": "recepta na okulary", "created_at": "2022-01-21"}
        };
        Navigator.pushReplacementNamed(context, '/product_list', arguments: {
          'documents': documentsData,
        });
        break;
      case 'receipt':
        var receiptData = {
          "receipt1": {"name": "Lidl", "price": "23.23", "created_at": "2022-04-31"},
          "receipt2": {"name": "Biedronka", "price": "17.15", "created_at": "2022-04-28"},
          "receipt3": {"name": "Kaufland", "price": "64.99", "created_at": "2022-04-27"}
        };
        Navigator.pushReplacementNamed(context, '/product_list', arguments: {
          'receipt': receiptData,
        });
        break;
    }
  }

  Future<http.Response> createAlbum() {
    print('go');
    var test =  http.post(
      Uri.parse('http://parameters-rouge-casio-clients.trycloudflare.com/Samochod'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': 'Polonez',
        'engine': '1.8ohjv',
        'production_data': '1989',
      }),
    );
    print(test.toString());
    return test;
  }

  @override
  Widget build(BuildContext context) {
    //print("Data fetched: ${widget.data['userData']['cars']}");\

    print('szerokosc (px): ${widget.size.width}');
    print('wysokosc (px): ${widget.size.height}');
    return Column(
      children: [
        Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
              decoration: BoxDecoration(
                color: primaryBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 50, 5, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     navigateTo('cars');
                        //   },
                        // ),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Container(
                              height: 120,
                              width: (widget.size.width/2),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Text("${widget.data['userData']['cars'][0]['name']} ${widget.data['userData']['cars'][0]['engine']}")
                                    SizedBox(height: 10),
                                    Text("SAMOCHODYY", style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                  color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 2.0 )),
                                    SizedBox(height: 10),
                                    Text("Aktualna liczba pojazdów: ${widget.data['userData']['cars'].length}"),
                                    ElevatedButton(onPressed: () {
                                       createAlbum();
                                    }, child: Text("kliknij mnie łobuizie"),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Container(
                              height: 140,
                              width: (widget.size.width/2),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Text("${widget.data['userData']['cars'][0]['name']} ${widget.data['userData']['cars'][0]['engine']}")
                                    SizedBox(height: 10),
                                    Text("PARAGONY", style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                        color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 2.0 )),
                                    SizedBox(height: 10),
                                    Text("Aktualna liczba paragonów: ${widget.data['userData']['cars'].length}"),
                                    ElevatedButton(onPressed: () {
                                      createAlbum();
                                    }, child: Text("kliknij mnie łobuizie"),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Container(
                              height: 140,
                              width: (widget.size.width/2),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Text("${widget.data['userData']['cars'][0]['name']} ${widget.data['userData']['cars'][0]['engine']}")
                                    SizedBox(height: 10),
                                    Text("DOKUMENTY", style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                        color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 2.0 )),
                                    SizedBox(height: 10),
                                    Text("Aktualna liczba dokumentów: ${widget.data['userData']['cars'].length}"),
                                    ElevatedButton(onPressed: () {
                                      createAlbum();
                                    }, child: Text("kliknij mnie łobuizie"),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
        )
      ],
    );
  }
}
