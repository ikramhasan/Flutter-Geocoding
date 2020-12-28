import 'package:mapbox_test/api/api.constants.dart';
import 'package:mapbox_test/api/models/forward_geocoding_model.dart';
import 'package:mapbox_test/api/models/geocoding.model.dart';
import 'package:mapbox_test/api/providers/api.provider.dart';
import 'package:mapbox_test/api/repositories/iapi.repository.dart';
import 'package:mapbox_test/utils/config.helper.dart';

class ApiRepository implements IApiRepository {
  static final ApiRepository instance = ApiRepository._();
  final ApiProvider _provider = ApiProvider(baseURL: MAPBOX_BASE_URL);

  ApiRepository._();

  @override
  Future performReverseGeocoding(
    double latitude,
    double longitude,
  ) async {
    final apiToken = (await loadConfigFile())['mapbox_api_token'] as String;
    final result = await _provider.makeGetRequest(
      'geocoding/v5/mapbox.places/$longitude,$latitude.json',
      queryParams: {
        'access_token': apiToken,
      },
    );

    return result != null ? GeocodingModel.fromJson(result) : GeocodingModel();
  }

  @override
  Future performForwardGeocoding(String placeName) async {
    final apiToken = (await loadConfigFile())['mapbox_api_token'] as String;
    final result = await _provider.makeGetRequest(
      'geocoding/v5/mapbox.places/$placeName.json',
      queryParams: {
        'access_token': apiToken,
      },
    );

    return result != null
        ? ForwardGeocodingModel.fromJson(result)
        : ForwardGeocodingModel();
  }
}
