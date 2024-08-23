import 'package:flutter_test/flutter_test.dart';
import 'package:medicus_flutter/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('DoctorViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
