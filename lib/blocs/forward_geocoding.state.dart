import 'package:mapbox_test/api/models/forward_geocoding_model.dart';

abstract class ForwardGeocodingState {
  const ForwardGeocodingState();
}

class InitialForwardGeocodingState extends ForwardGeocodingState {}

class LoadingForwardGeocodingState extends ForwardGeocodingState {}

class SuccessfulForwardGeocodingState extends ForwardGeocodingState {
  final ForwardGeocodingModel data;

  const SuccessfulForwardGeocodingState(this.data);
}

class FailedForwardGeocodingState extends ForwardGeocodingState {
  final String error;

  const FailedForwardGeocodingState({this.error = 'Failed to get data'});
}
