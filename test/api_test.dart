import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_test/api/repositories/api.repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => HttpOverrides.global = null);

  group(
    'mapbox api',
    () {
      test(
        'forward geocoding response',
        () async {
          final repository = ApiRepository.instance;
          final result = await repository.performForwardGeocoding('Dhaka');
          print(result.toString());
          expect(result.attribution.isNotEmpty, true);
        },
      );
    },
  );
}
