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
      "name": "Opel Astra J",
      "engine": "1.8hp",
      "production_date": "1994"
    },
     {
      "name": "Mitsubishi Eclipse",
      "engine": "1.3",
      "production_date": "1980"
    },
     {
      "name": "opel astra f",
      "engine": "1.6",
      "production_date": "2000"
    },
    {
      "name": "opel astra f",
      "engine": "1.6",
      "production_date": "2000"
    },
    {
      "name": "opel astra f",
      "engine": "1.6",
      "production_date": "2000"
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
                      height: 130,
                        width: 150,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 10, 0 ,0),
                                        child: Text("${carsData[index]['name']}", style: TextStyle(
                                          fontSize: carsData[index]['name']!.length > 15 ? (14):(18),
                                        ),),
                                      ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("OKRES WAŻNOŚCI", style: TextStyle(
                                                  color: fontGrey,
                                                  fontFamily: "Roboto",
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  letterSpacing: 1.2
                                                )),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(25),
                                                    color: bg35Grey
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(10,0,10,0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Icon(Icons.text_snippet_outlined, color: icon70Black),
                                                        Text("320 dni",
                                                          style: TextStyle(
                                                          fontFamily: "Lato",
                                                          fontWeight: FontWeight.w400
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(25),
                                                      color: bg35Grey
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Icon(Icons.car_repair_outlined, color: icon70Black),
                                                        Text("320 dni",
                                                          style: TextStyle(
                                                              fontFamily: "Lato",
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                    ],
                                  ),
                                ),
                                // FittedBox(child: Image.asset("assets/asterka.jpg"), fit: BoxFit.fill)
                                Expanded(
                                  flex: 10,
                                  child: SizedBox(
                                    width: 200,
                                    child: Stack(
                                    children: [
                                      Positioned.fill(
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(0, 100, 200, 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: main25Color,

                                          ),
                                          width: 90,
                                          height: 150,
                                        ),
                                      ),
                                      Positioned.fill(
                                          right: 70,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: main50Color,
                                              ),
                                              width: 90,
                                              height: 150,
                                            ),
                                          )
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(25),
                                            child: Image(
                                              width: 170,
                                              height: 150,
                                              fit: BoxFit.cover,
                                              alignment: Alignment(-0.5,0),
                                              image: AssetImage("assets/asterka.jpg"),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                              ),
                                  ),
                                ),
                          ],
                        ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent,),
          ),
        ),
      ),
    );
  }
}
