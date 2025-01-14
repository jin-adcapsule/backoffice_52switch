
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
// Convert Employee to Map
  Map<String, dynamic> toJson() => {
        'locationId': locationId,
        'workplace': workplace,
        'workhourOn': workhourOn,
        'workhourOff': workhourOff,
        'workhourHalf': workhourHalf,

      };
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
