import 'package:uuid/uuid.dart';



class CustRecord {
  static var uuid = const Uuid();

  String id = uuid.v4();
  double uLatitude = 0.0, uLongitude = 0.0, dLatitude = 0.0, dLongitude = 0.0;
  String uPlaceId = "", dPlaceId = "";
  String description = '';
  bool complete = false;
  DateTime date = DateTime.now();
  String title = '';
  
  CustRecord.fromMap(this.id, this.uLatitude, this.uLongitude, this.uPlaceId, this.dLatitude, this.dLongitude, this.dPlaceId, this.description, this.complete, this.title);

  CustRecord(this.uLatitude, this.uLongitude, this.uPlaceId, this.dLatitude, this.dLongitude, this.dPlaceId, this.description, this.complete, this.title);
  
  Map<String, Object> toMap() => 
  {
    'id' : id,
    'uLatitude' : uLatitude,
    'uLongitude' : uLongitude, 
    'uPlaceId' : uPlaceId,
    'dLatitude' : dLatitude,
    'dLongitude' : dLongitude,
    'dPlaceId' : dPlaceId,
    'description' : description,
    'date' : date,
    'complete' : complete == true ? 1 : 0,
    'title' : title
  };

  CustRecord fromMap(Map<dynamic, dynamic> map) {
    id = map['id'] as String;
    uLatitude = map['uLatitude'] as double;
    uLongitude = map['uLongitude'] as double;
    uPlaceId = map['uPlaceId'] as String;
    dLatitude = map['dLatitude'] as double;
    dLongitude = map['dLongitude'] as double;
    dPlaceId = map['dPlaceId'] as String;
    description = map['description'] as String;
    date = map['date'] as DateTime;
    complete = (map['complete'] as int == 1 ? true : false);
    title = map['title'] as String;
    return CustRecord.fromMap(id, uLatitude, uLongitude, uPlaceId, dLatitude, dLongitude, dPlaceId, description, complete, title);
  }

}