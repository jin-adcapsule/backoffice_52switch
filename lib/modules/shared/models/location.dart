//Employee model can handle the response from the GraphQL API.
import 'package:backoffice52switch/modules/shared/models/employee.dart';

class Location {
   String locationId;
   String workplace; 
   String workhourOn; 
   String workhourOff; 
   String workhourHalf; 

  Location({
    required this.locationId,
    required this.workplace,
    required this.workhourOn,
    required this.workhourOff,
    required this.workhourHalf,
   
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['_id'],
      workplace: json['workplace'] ,

      workhourOn: json['workhourOn'],
      workhourOff: json['workhourOff'],
      workhourHalf: json['workhourHalf'],

    );
  }
}
