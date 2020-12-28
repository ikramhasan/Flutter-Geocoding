import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_test/blocs/forward_geocoding.bloc.dart';
import 'package:mapbox_test/blocs/forward_geocoding.event.dart';
import 'package:mapbox_test/blocs/forward_geocoding.state.dart';
import 'package:mapbox_test/blocs/geocoding.bloc.dart';
import 'package:mapbox_test/blocs/geocoding.event.dart';
import 'package:mapbox_test/blocs/geocoding.state.dart';
import 'package:mapbox_test/keys/key.dart';
import 'package:mapbox_test/utils/config.helper.dart';
import 'package:mapbox_test/utils/location.helper.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<String> mapStyles = [
    'mapbox://styles/mapbox/dark-v10',
    'mapbox://styles/mapbox/light-v10',
    'mapbox://styles/mapbox/streets-v11',
    'mapbox://styles/mapbox/outdoors-v11',
    'mapbox://styles/mapbox/satellite-v9',
    'mapbox://styles/mapbox/satellite-streets-v11',
    'mapbox://styles/mapbox/traffic-day-v2',
    'mapbox://styles/mapbox/traffic-night-v2',
  ];

  String placeName;
  LatLng finalLocation;

  @override
  Widget build(BuildContext context) {
    MapboxMapController _mapController;
    TextEditingController _locationTextController = TextEditingController();
    Symbol symbol = Symbol(
      'marker',
      SymbolOptions(
        iconColor: '#D21404',
        iconImage: 'place_icon',
        draggable: false,
        iconSize: 1,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: TextField(
          controller: _locationTextController,
          decoration: InputDecoration(hintText: 'Search location'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                placeName = _locationTextController.text;
              });
              BlocProvider.of<ForwardGeocodingBloc>(context)
                ..add(RequestForwardGeocodingEvent(placeName));
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BlocBuilder<ForwardGeocodingBloc,
                      ForwardGeocodingState>(
                    builder: (ctx, state) {
                      if (state is LoadingForwardGeocodingState) {
                        return Container(
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is SuccessfulForwardGeocodingState) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.data.features.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  final locationTemp = LatLng(
                                      state.data.features[index].geometry
                                          .coordinates.last,
                                      state.data.features[index].geometry
                                          .coordinates.first);
                                  finalLocation = locationTemp;
                                  Navigator.pop(context);
                                  try {
                                    _mapController.clearSymbols();
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                  await _mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: locationTemp,
                                        zoom: 12,
                                      ),
                                    ),
                                  );

                                  await _mapController.addSymbol(
                                    symbol.options.copyWith(
                                      SymbolOptions(geometry: locationTemp),
                                    ),
                                  );
                                  BlocProvider.of<GeocodingBloc>(context)
                                    ..add(RequestGeocodingEvent(
                                        locationTemp.latitude,
                                        locationTemp.longitude));
                                },
                                child: ListTile(
                                  title: Text(
                                      state.data.features[index].placeName),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (state is FailedForwardGeocodingState) {
                        return ListTile(
                          title: Text('Error'),
                          subtitle: Text(state.error),
                        );
                      } else {
                        return ListTile(
                          title: Text('Error'),
                          subtitle: Text('Unknown Error Occurred'),
                        );
                      }
                    },
                  );
                },
              );
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: loadConfigFile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final token = API_TOKEN;
              return MapboxMap(
                styleString: mapStyles[0],
                minMaxZoomPreference: MinMaxZoomPreference(0, 22),
                accessToken: token,
                initialCameraPosition: CameraPosition(
                  zoom: 1.0,
                  target: LatLng(40.52, 34.35),
                ),
                onMapClick: (point, coordinates) async {
                  _mapController.clearSymbols();
                  finalLocation = coordinates;
                  await _mapController.addSymbol(
                    symbol.options.copyWith(
                      SymbolOptions(geometry: coordinates),
                    ),
                  );

                  _mapController.onSymbolTapped.add((argument) async {
                    BlocProvider.of<GeocodingBloc>(context)
                      ..add(RequestGeocodingEvent(
                          coordinates.latitude, coordinates.longitude));
                    _showBottomModalSheet(context);
                  });
                },
                onMapCreated: (controller) async {
                  _mapController = controller;
                  final location = await getCurrentLocation();
                  finalLocation = location;
                  final ByteData imageBytes =
                      await rootBundle.load('assets/marker.png');
                  final Uint8List bytesList = imageBytes.buffer.asUint8List();
                  await _mapController.addImage('place_icon', bytesList);
                  await _mapController.addSymbol(
                    symbol.options.copyWith(
                      SymbolOptions(geometry: location),
                    ),
                  );

                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: location,
                        zoom: 14,
                      ),
                    ),
                  );
                  controller.onSymbolTapped.add((argument) async {
                    BlocProvider.of<GeocodingBloc>(context)
                      ..add(RequestGeocodingEvent(
                          location.latitude, location.longitude));
                    _showBottomModalSheet(context);
                  });
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        child: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<GeocodingBloc>(context)
              ..add(RequestGeocodingEvent(
                  finalLocation.latitude, finalLocation.longitude));
            _showBottomModalSheet(context);
          },
          child: Text('Add'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ),
      ),
    );
  }
}

void _showBottomModalSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return BlocBuilder<GeocodingBloc, GeocodingState>(
        builder: (ctx, state) {
          if (state is LoadingGeocodingState) {
            return Container(
              height: 150,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is SuccessfulGeocodingState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  ListTile(
                    title: Text(state.data.placeName),
                  ),
                  ListTile(
                    title: Text('Coordinates'),
                    subtitle: Text(
                        '${state.data.latitude.toStringAsFixed(3)}/${state.data.longitude.toStringAsFixed(3)}'),
                  ),
                ],
              ),
            );
          } else if (state is FailedGeocodingState) {
            return ListTile(
              title: Text('Error'),
              subtitle: Text(state.error),
            );
          } else {
            return ListTile(
              title: Text('Error'),
              subtitle: Text('Unknown Error Occurred'),
            );
          }
        },
      );
    },
  );
}
