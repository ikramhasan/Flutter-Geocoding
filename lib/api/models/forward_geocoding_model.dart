class ForwardGeocodingModel {
  String type;
  List<String> query;
  List<Features> features;
  String attribution;

  ForwardGeocodingModel({
    this.type = '',
    this.query = const [],
    this.features = const [],
    this.attribution = '',
  });

  @override
  String toString() => '$runtimeType($attribution, ${features[0].placeName})';

  ForwardGeocodingModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    query = json['query'].cast<String>();
    if (json['features'] != null) {
      features = new List<Features>();
      json['features'].forEach((v) {
        features.add(new Features.fromJson(v));
      });
    }
    attribution = json['attribution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['query'] = this.query;
    if (this.features != null) {
      data['features'] = this.features.map((v) => v.toJson()).toList();
    }
    data['attribution'] = this.attribution;
    return data;
  }
}

class Features {
  String id;
  String type;
  List<String> placeType;
  double relevance;
  Properties properties;
  String text;
  String placeName;
  List<double> center;
  Geometry geometry;
  List<Context> context;
  String matchingText;
  String matchingPlaceName;
  List<double> bbox;

  Features({
    this.id,
    this.type,
    this.placeType,
    this.relevance,
    this.properties,
    this.text,
    this.placeName,
    this.geometry,
    this.context,
    this.matchingText,
    this.matchingPlaceName,
  });

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    placeType = json['place_type'].cast<String>();
    relevance = json['relevance'].toDouble();
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    text = json['text'];
    placeName = json['place_name'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    if (json['context'] != null) {
      context = new List<Context>();
      json['context'].forEach((v) {
        context.add(new Context.fromJson(v));
      });
    }
    matchingText = json['matching_text'];
    matchingPlaceName = json['matching_place_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['place_type'] = this.placeType;
    data['relevance'] = this.relevance;
    if (this.properties != null) {
      data['properties'] = this.properties.toJson();
    }
    data['text'] = this.text;
    data['place_name'] = this.placeName;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    if (this.context != null) {
      data['context'] = this.context.map((v) => v.toJson()).toList();
    }
    data['matching_text'] = this.matchingText;
    data['matching_place_name'] = this.matchingPlaceName;
    return data;
  }
}

class Properties {
  String foursquare;
  bool landmark;
  String address;
  String category;
  String maki;
  String accuracy;

  Properties(
      {this.foursquare,
      this.landmark,
      this.address,
      this.category,
      this.maki,
      this.accuracy});

  Properties.fromJson(Map<String, dynamic> json) {
    foursquare = json['foursquare'];
    landmark = json['landmark'];
    address = json['address'];
    category = json['category'];
    maki = json['maki'];
    accuracy = json['accuracy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foursquare'] = this.foursquare;
    data['landmark'] = this.landmark;
    data['address'] = this.address;
    data['category'] = this.category;
    data['maki'] = this.maki;
    data['accuracy'] = this.accuracy;
    return data;
  }
}

class Geometry {
  List<double> coordinates;
  String type;

  Geometry({this.coordinates, this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>() ?? [0.0];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coordinates'] = this.coordinates;
    data['type'] = this.type;
    return data;
  }
}

class Context {
  String id;
  String wikidata;
  String text;
  String shortCode;

  Context({this.id, this.wikidata, this.text, this.shortCode});

  Context.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wikidata = json['wikidata'];
    text = json['text'];
    shortCode = json['short_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['wikidata'] = this.wikidata;
    data['text'] = this.text;
    data['short_code'] = this.shortCode;
    return data;
  }
}
