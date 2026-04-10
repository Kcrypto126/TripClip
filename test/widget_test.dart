import 'package:flutter_test/flutter_test.dart';

import 'package:tripclip/app/trip_clip_app.dart';

void main() {
  testWidgets('TripClip shell renders', (WidgetTester tester) async {
    await tester.pumpWidget(const TripClipApp());
    await tester.pumpAndSettle();

    expect(find.text('TripClip'), findsWidgets);
    expect(find.text('Parcels'), findsNWidgets(2));
  });
}
