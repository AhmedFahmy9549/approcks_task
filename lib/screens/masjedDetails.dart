import 'package:approcks_task/models/mosque_model.dart';
import 'package:flutter/material.dart';

import 'map_screen.dart';

class MasjadDetails extends StatelessWidget {
  final Datum masjedMode;

  MasjadDetails(this.masjedMode);

  @override
  Widget build(BuildContext context) {
    checkImageAvailabile();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "المساجد القريبة",
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          )
        ],
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.brown,
        padding: EdgeInsets.all(10.0),
        child: Card(
          color: Colors.white,
          elevation: 8.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: checkImageAvailabile()
                      ? Image.asset("assets/images/icon_masjed.png")
                      : Image.network(masjedMode.imagesUrl)),
              Visibility(
                visible: checkImageAvailabile(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "لا يوجد صور للمسجد",
                    style: TextStyle(color: Colors.black.withOpacity(0.9)),
                  ),
                ),
              ),
              Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.green[900],
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapScreen(masjedMode)));
                          },
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "الاتجاهات",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              Icon(
                                Icons.directions,
                                size: 30,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.teal,
                          height: MediaQuery.of(context).size.height,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                "${masjedMode.distance.toStringAsFixed(1)} km",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${masjedMode.nameAr} ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  bool checkImageAvailabile() {
    return masjedMode.imagesUrl.length < 5 ? true : false;
  }
}
