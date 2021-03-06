class GeocodingModel {
  double latitude;
  double longitude;
  double magnitude;
  String placeName;

  GeocodingModel({
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.placeName = '',
  });

  GeocodingModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> coordinates = json['query'];
    this.latitude = coordinates.first;
    this.longitude = coordinates.last;
    this.placeName = json['features'][0]['place_name'] as String;
  }

  @override
  String toString() => '$runtimeType($latitude, $longitude, $placeName)';
}
