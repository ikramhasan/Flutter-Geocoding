import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_test/blocs/forward_geocoding.bloc.dart';
import 'package:mapbox_test/blocs/geocoding.bloc.dart';
import 'package:mapbox_test/screens/map.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<GeocodingBloc>(
          create: (context) => GeocodingBloc(),
        ),
        BlocProvider<ForwardGeocodingBloc>(
          create: (context) => ForwardGeocodingBloc(),
        ),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Earthquake Visualizer',
      theme: ThemeData(
        brightness: Brightness.dark,
        canvasColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}
