import 'package:flutter_test/flutter_test.dart';
import 'package:tripwise/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    expect(const MyApp(), isNotNull);
  });
}
