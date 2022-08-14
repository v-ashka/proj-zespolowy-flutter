import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';

class carList extends StatefulWidget {
  const carList({Key? key}) : super(key: key);

  @override
  State<carList> createState() => _carListState();
}

class _carListState extends State<carList> {

  final carsData = [
     {
      "name": "polonez",
      "engine": "1.8hp",
      "production_date": "1994"
    },
     {
      "name": "fiat 126p",
      "engine": "1.3",
      "production_date": "1980"
    },
     {
      "name": "opel astra f",
      "engine": "1.6",
      "production_date": "2000"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    print(carsData[0]);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:  AppBar(
        elevation: 0,
        title: Text('Pojazdy mechaniczne'),
        leading: Icon(Icons.arrow_back_ios),
        foregroundColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1, fontFamily: 'Lato', fontSize: MediaQuery.of(context).textScaleFactor * 18),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/background2.png'), fit: BoxFit.fill)
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child:
                ListView.separated(
                padding: const EdgeInsets.all(20),
                  itemCount: carsData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      width: 50,
                      height: 120,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                                Column(
                                  children: [
                                    Text("${carsData[index]['name']}"),
                                  ],
                                ),
                                FittedBox(child: Image.asset("assets/asterka.jpg"), fit: BoxFit.fill)
                          ],
                        ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        ),
      ),
    );
  }
}
