
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:replicanano2_malarm/core/entities/places.dart';
import 'package:replicanano2_malarm/data/repository/remoteAPIRepository.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GetRouteUsecase{

  RemoteAPIRepository repo = RemoteAPIRepository();
  PolylinePoints polyLineDecoder = PolylinePoints();
  Future<(List<LatLng>, int)> getRoute(Place origin, Place dest) async {
    
    print("inside future willStartOper");

    var response = await repo.googleRouteDataSource.getRoute(origin, dest);
    List<PointLatLng> polylinePoints = polyLineDecoder.decodePolyline(response.polyLine);
    List<LatLng> latlong = polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList();

    print("done Oper with : $latlong, and estimated time : ${response.second}");
    return (latlong, response.second);
  }
}