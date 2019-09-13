import 'package:approcks_task/DB/database_helper.dart';
import 'package:approcks_task/commons/constants.dart';
import 'package:approcks_task/services/connectivity_checker.dart';
import 'package:approcks_task/services/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/location.dart';
import '../models/mosque_model.dart';
import 'masjedDetails.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  ScrollController controller = ScrollController();
  LocationServices _locationServices = LocationServices();
  bool hasPermission = false;
  bool hasServiceEnabled = false;
  List<Datum> listMasjids = List();
  MosqueModel model;
  double height = 5;
  double radius = 5;
  int currentPage = 1;
  int lastPage = 1;
  double long, lat;
  bool checkConnectivity;

  Data handler = Data();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkPermissionsLocation();

    // subscribe to connection state
    Provider.of<ConnectivityChecker>(context, listen: false)
        .checkConnectivity();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (currentPage > lastPage) {
          isLoading = false;
        } else {
          currentPage++;
          getData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // listen to connection state
    final connectionState = Provider.of<ConnectivityChecker>(context);
    checkInternetConnection(connectionState.connectivityState);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
         centerTitle: true,
          title: Text(
            "المساجد القريبة",
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
        body: Container(
          color: Colors.brown,
          child: Container(
            margin: EdgeInsets.all(8.0),
            color: Colors.lime[100],
            padding: EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                checkConnectivity
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 50,
                              color: Colors.teal[400],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "0.5 KM",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          backgroundColor: Colors.transparent,
                                          color: Colors.white),
                                    ),
                                    SliderTheme(
                                      data: kSliderTheme,
                                      child: Slider(
                                          onChangeEnd: (newValue) {
                                            listMasjids = new List();
                                            currentPage = 1;
                                            radius = newValue;

                                            getData();
                                          },
                                          min: kMinHeight,
                                          max: kMaxHeight,
                                          value: height.toDouble(),
                                          onChanged: (double newValue) {
                                            setState(() {
                                              height = newValue;
                                            });
                                          }),
                                    ),
                                    Expanded(
                                      child: Text("10 KM",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              backgroundColor: Colors.transparent,
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.green[900],
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Text(
                                "${height.toStringAsFixed(1)} KM",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            "No Internet Connection",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                Expanded(
                    child: ListView.builder(
                        controller: controller,
                        itemCount: listMasjids.length,
                        itemBuilder: (ctx, index) {
                          return InkWell(
                            onTap: () {
                              //listMasjids[0]
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MasjadDetails(listMasjids[index])));
                            },
                            child: Card(
                              elevation: 5.0,

                              child: (ListTile(
                                leading: Icon(Icons.arrow_back_ios),
                                title: Text(
                                    "${listMasjids[index].distance.toStringAsFixed(1)} km"),
                                trailing: Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    child: Text(
                                      "${listMasjids[index].nameAr}",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      maxLines: 1,
                                    )),
                              )),
                            ),
                          );
                        })),
                isLoading
                    ? Container(
                        height: 50,
                        margin: EdgeInsets.all(5),
                        child: Center(child: CircularProgressIndicator()))
                    : Container(),
              ],
            ),
          ),
        ));
  }

  void dialogWidget() {
    showDialog(
      context: context,
      builder: (contx) {
        return AlertDialog(
          title: Text("Open Location "),
          content: Text("would you open location "),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () async {
                bool checker = await _locationServices.requestForPermission();

                if (checker) {
                  var currentLocation = await _locationServices.getLocation();
                  if (currentLocation != null) {
                    long = currentLocation.longitude;
                    lat = currentLocation.latitude;
                    Navigator.pop(context);

                    getData();
                  }
                }
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(contx);
              },
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  void checkPermissionsLocation() async {
    hasPermission = await _locationServices.checkHasPermission();
    hasServiceEnabled = await _locationServices.checkServiceEnabled();
    if (!hasPermission) {
      hasPermission = await _locationServices.requestForPermission();
    }
    if (hasPermission && hasServiceEnabled) {
      var location = await _locationServices.getLocation();
      long = location.longitude;
      lat = location.latitude;

      getData();
    } else {
      dialogWidget();
    }
  }

  getData() async {
    isLoading = true;
    setState(() {});
    // checkConnectInternent();

    model = await handler.fetchData(
        valueRadius: radius, latitude: lat, longitude: long, page: currentPage);
    lastPage = model.meta.lastPage;
    listMasjids.addAll(model.data);
    saveData(listMasjids);
    isLoading = false;
    setState(() {});
  }

  void saveData(List<Datum> listMasjds) async {
    listMasjds.forEach((datum) {
      DatabaseHelper helper = DatabaseHelper.instance;
      helper.queryExistItem(datum.id).then((isExist) async {
        if (isExist == false) {
          await helper.insert(datum);
        }
      });
    });
  }

  void readData() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var x = await helper.queryMasjads();
    x.forEach((datum) {
      //print(datum.id);
    });
  }

  void checkInternetConnection(String connectivityState) {
    if (connectivityState == "disconnected")
      setState(() {
        checkConnectivity = false;
      });
    else {
      setState(() {
        checkConnectivity = true;
      });
    }
  }
}
