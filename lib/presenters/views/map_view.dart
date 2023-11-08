// ignore_for_file: prefer_const_constructors

import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:replicanano2_malarm/core/services/geolocator.dart';

import 'package:replicanano2_malarm/data/usecases/ReverseGeoCoding.dart';

import '../../core/entities/places.dart';


class mapPage extends StatefulWidget {
  const mapPage({super.key});

  @override
  State<mapPage> createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {
  ReverseGeocodingUsecase revGeoCode = ReverseGeocodingUsecase();

  final Completer<GoogleMapController> _controller = Completer();
  Position? currDevicePosition;
  

  Set<Marker> userMarker = <Marker>{Marker(markerId: MarkerId("UserMarker"),)};
  Place? userPlace;
  Place? destPlace;

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Long press to select Place"),
        leading: CupertinoNavigationBarBackButton(),
        trailing: GestureDetector(
          onTap: () {
            if ((userMarker.map((e) => e.markerId) as Set).containsAll({
              MarkerId("UserMarker"),
              MarkerId("destinationMarker")
            })) {
              var destinationMarker = userMarker.firstWhere((m) => m.markerId == MarkerId("destinatiuonMarker"));

              
                // Set<(String, Map<String, (Place, Marker)>)> results = <(String, Map<String, (Place, Marker)>)>{(
                //   "${destinationMarker.infoWindow.title}", {"user" : (userPlace!, userMarker.firstWhere((m) => m.markerId == MarkerId("UserMarker")))}
                // )};
              
              
              if (userPlace != null && destPlace != null) {
                Navigator.pop(
                  context, 
                  <(String, Map<String, (Place, Marker)>)>{(
                    "${destinationMarker.infoWindow.title}", {
                      "user" : (userPlace!, userMarker.firstWhere((m) => m.markerId == MarkerId("UserMarker"))),
                      "dest" : (destPlace!, destinationMarker)
                      }
                  )});
              }
            }
          },
          child: Text("Done"),
        ),
      ),
      child: Scaffold(
        // MARK: Google Map Code
        body: GoogleMap(
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(0,0),
          ),
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
          onLongPress : (latlong) async {
            var destPlace = await revGeoCode.call(latlong);
            destPlace.latNlong = latlong;
            setState(() {
              this.destPlace = destPlace;
            });

            Marker destinationMarker = Marker(
              markerId: MarkerId("destinationMarker"),
              position: this.destPlace?.latNlong ?? LatLng(0.0, 0.0),
              infoWindow: InfoWindow(
                title: this.destPlace?.name ?? ""
              )
            );

            setState(() {
              this.destPlace = destPlace;
              userMarker.add(destinationMarker);
            });
          },
          markers: userMarker,

          /* MARK: drag user marker to change the user latlong if needed */ 
          // onCameraMove: (position) {
          //   setState(() {
          //     userMarker.add(Marker(markerId: MarkerId("UserMarker"), position : position.target, infoWindow: InfoWindow(title: "Your Current Position")));
          //   });
          // },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getcurrentloc();
          },
          child: Icon(Icons.location_pin),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentloc();
  } 

  void getcurrentloc() async {
    var retrievedLoc = await determinePosition();

    var place = await revGeoCode.call(LatLng(retrievedLoc.latitude, retrievedLoc.longitude));
    setState(() {
      userPlace = place;
      currDevicePosition = retrievedLoc;
      
      // userMarker = <Marker>{Marker(markerId: MarkerId("UserMarker"), position: LatLng(currDevicePosition!.latitude, currDevicePosition!.longitude))};
      userMarker.add(Marker(markerId: MarkerId("UserMarker"), position: LatLng(currDevicePosition!.latitude, currDevicePosition!.longitude), infoWindow: InfoWindow(title : (place.name != "") ? place.name : "Your Current Location")));
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(currDevicePosition!.latitude, currDevicePosition!.longitude), zoom: 19))
    );
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposeController();
    super.dispose();
  }
}