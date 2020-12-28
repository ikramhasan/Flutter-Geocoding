abstract class IApiRepository {
  Future<dynamic> performReverseGeocoding(
    double latitude,
    double longitude,
  );

  Future<dynamic> performForwardGeocoding(
    String placeName,
  );
}
