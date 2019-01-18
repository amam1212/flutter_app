import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'google_map.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;
  MapType _currentMapType = MapType.normal;


  final LatLng _center = const LatLng(18.785244, 98.9862145);


  final urlJSONString = "http://www.cmtransit.com/API/station/";

  List<station> myAllData = [];

  @override
  void initState() {
    loadData();
  }

  void loadData() async {
    var respense = await http.get(urlJSONString, headers: {"Aceept": "application/json"});
    if (respense.statusCode == 200) {
      String responseBodyString = respense.body;
      print('responseBodyString ==> ' + responseBodyString);
      var jsonBody = json.decode(responseBodyString);
      for (var data in jsonBody) {
        myAllData.add(new station(
            data['id'], data['station_name'], double.parse(data['point_lat']), double.parse(data['point_lng']),data['type']));
      }
      setState(() {
//        myAllData.forEach((nameData) {
//          print('name ==> ${nameData.station_name}');
//        });
//      for(int i =0;i <= myAllData.length-1;i++){
//        print('name ==>' +myAllData[i].station_name);
//      }
      });
    } else {
      print('Somethaing Wrong');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  void _onMapTypeButtonPressed() {
    if (_currentMapType == MapType.normal) {
      mapController.updateMapOptions(
        GoogleMapOptions(mapType: MapType.satellite),
      );
      _currentMapType = MapType.satellite;
    } else {
      mapController.updateMapOptions(
        GoogleMapOptions(mapType: MapType.normal),
      );
      _currentMapType = MapType.normal;
    }
  }

  void _onAddMarkerButtonPressed() {
    for(int i =0;i <= myAllData.length-1;i++) {

          mapController.addMarker(
          MarkerOptions(
          position:
          LatLng(
            myAllData[i].lat,
            myAllData[i].lng,
          )
          ,
          infoWindowText: InfoWindowText('Random Place', '5 Star Rating'),
//          icon: BitmapDescriptor.defaultMarker,
          icon: BitmapDescriptor.fromAsset('images/'+ myAllData[i].type +'_busstop.png'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              options: GoogleMapOptions(
                trackCameraPosition: true,
                cameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.map, size: 36.0),
                    ),
                    const SizedBox(height: 16.0),
                    FloatingActionButton(
                      onPressed: _onAddMarkerButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.add_location, size: 36.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }



}



