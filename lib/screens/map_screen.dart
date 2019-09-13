import 'dart:async';
import 'package:approcks_task/models/mosque_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  final Datum model;

  MapScreen(this.model);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kGooglePlex = CameraPosition(
    target: _center,
    zoom: 18.0,
  );

  static const LatLng _center = const LatLng(31.17421, 30.002759999999995);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

//add your lat and lng where you wants to draw polyline

  List<LatLng> latlng = List();
  static LatLng masjedLatLng;
  static LatLng userLatLng;

  static final CameraPosition _kPosition = CameraPosition(
      target: userLatLng, tilt: 59.440717697143555, zoom: 15.151926040649414);

  void _onAddMarkerButtonPressed() async {

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(masjedLatLng.toString()),
        position: masjedLatLng,
        infoWindow: InfoWindow(title: widget.model.nameAr, snippet: ''),
        icon: BitmapDescriptor.defaultMarker,
      ));
      _polyline.add(Polyline(
          polylineId: (PolylineId(masjedLatLng.toString())),
          visible: true,
          points: latlng,
          color: Colors.blue));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLocation();
    masjedLatLng = LatLng(widget.model.longitude, widget.model.latitude);
    latlng.add(masjedLatLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        GoogleMap(
          polylines: _polyline,
          markers: _markers,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: _handleTap,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
        ),

        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                label: Text("Go to Masjeds"),
                icon: Icon(Icons.gps_fixed),
                materialTapTargetSize: MaterialTapTargetSize.padded,
                heroTag: "TAg1",
                onPressed: _onAddMarkerButtonPressed,
              ),
            ))
      ],
    ));
  }

  getUserLocation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      double long = prefs.get("long");
      double lat = prefs.get("lat");
      userLatLng = LatLng(lat, long);
      latlng.add(userLatLng);

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_kPosition));
      setState(() {

        _markers.add(Marker(
          markerId: MarkerId(userLatLng.toString()),
          position: userLatLng,
          infoWindow: InfoWindow(title: "Home", snippet: ''),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    } catch (e) {}
  }

  _handleTap(LatLng point) {
    setState(() {
      latlng=List();
      latlng.add(masjedLatLng);
      latlng.add(point);
      _markers.add(Marker(
        markerId: MarkerId(userLatLng.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'new Home',
        ),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
    });
    _onAddMarkerButtonPressed();

  }

}
