import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_test/api/repositories/api.repository.dart';
import 'package:mapbox_test/blocs/forward_geocoding.event.dart';
import 'package:mapbox_test/blocs/forward_geocoding.state.dart';

class ForwardGeocodingBloc
    extends Bloc<ForwardGeocodingEvent, ForwardGeocodingState> {
  final _repository = ApiRepository.instance;
  ForwardGeocodingBloc() : super(InitialForwardGeocodingState());

  @override
  Stream<ForwardGeocodingState> mapEventToState(
      ForwardGeocodingEvent event) async* {
    if (event is RequestForwardGeocodingEvent) {
      yield LoadingForwardGeocodingState();

      final result = await _repository.performForwardGeocoding(event.placeName);

      if (result.attribution.isNotEmpty) {
        yield SuccessfulForwardGeocodingState(result);
      } else {
        yield FailedForwardGeocodingState(
            error: 'Failed to get data after api call');
      }
    } else {
      yield FailedForwardGeocodingState();
    }
  }
}
