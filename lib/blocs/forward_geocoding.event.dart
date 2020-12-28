abstract class ForwardGeocodingEvent {
  const ForwardGeocodingEvent();
}

class RequestForwardGeocodingEvent extends ForwardGeocodingEvent {
  final String placeName;

  const RequestForwardGeocodingEvent(this.placeName);
}
