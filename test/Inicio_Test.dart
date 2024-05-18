// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:event/Inicio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:event/main.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  });

    testWidgets('Inicio Widget Test', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: Inicio(),
      ));

      // Verify that the text fields and buttons are displayed correctly
      expect(find.text('ACCEDER'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('¿Olvidó su contraseña?'), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(3)); // Adjusted to the number of Image widgets in your widget

      // Tap the "¿Olvidó su contraseña?" text button
      await tester.tap(find.text('¿Olvidó su contraseña?'));
      await tester.pump();

      // Verify that navigation to the password reset page works
      expect(find.text('Reset Password Page'), findsOneWidget);

      // Tap the login button without entering credentials
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Verify that an error dialog is shown
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Por favor, ingrese su correo electrónico y contraseña.'), findsOneWidget);

      // Tap the register button
      await tester.tap(find.byType(InkWell).last);
      await tester.pump();

      // Verify that navigation to the registration page works
      expect(find.text('Crear Cuenta Page'), findsOneWidget);
    });
}
