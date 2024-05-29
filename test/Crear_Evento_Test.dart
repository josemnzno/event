// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:event/Crear_Evento.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  group('Crear_Evento Widget Tests', () {
    testWidgets('Widget Renders Correctly', (WidgetTester tester) async {

      await tester.pumpWidget(MaterialApp(
        home: Crear_Evento(),
      ));

      expect(find.text('Crear Evento'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(6));
      expect(find.byType(ElevatedButton), findsNWidgets(3)); // Adjusted to the number of ElevatedButtons in your widget
      expect(find.byType(GestureDetector), findsNWidgets(3));
      expect(find.byType(Image), findsNWidgets(3));
    });

    testWidgets('Selecting Image', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Crear_Evento(),
      ));

      await tester.tap(find.byType(GestureDetector).at(0));
      await tester.pump();
    });
  });
}
