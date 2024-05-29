// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:event/Crear_cuenta.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDVDgVLSW419qLFGlXYNaUC5xCKx-dKhHQ",
      appId: "1:985779589426:android:598f42e1a5c58ade37072b",
      messagingSenderId: "985779589426",
      projectId: "eveentapp"
    ),
  );

  group('UI Render Tests', () {
    testWidgets('Initial UI elements are displayed correctly', (
        WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Crear_cuenta()));

      expect(find.text('NUEVO USUARIO'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(7));
      expect(find.text('Crear cuenta'), findsOneWidget);
    });
  });

  group('Valid Data tests', () {
    testWidgets('Email validation error shown when email is invalid', (
        WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Crear_cuenta()));

      final emailField = find.byType(TextFormField).at(3);
      await tester.enterText(emailField, 'invalid_email');
      await tester.pump();

      expect(find.text('Ingrese un correo electrónico válido'), findsOneWidget);
    });

    testWidgets(
        'Password confirmation error shown when passwords do not match', (
        WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Crear_cuenta()));

      final passwordField = find.byType(TextFormField).at(5);
      final confirmPasswordField = find.byType(TextFormField).at(6);

      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'differentPassword');
      await tester.pump();

      expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
    });

    testWidgets('Phone validation error shown when phone number is invalid', (
        WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Crear_cuenta()));

      final phoneField = find.byType(TextFormField).at(2);
      await tester.enterText(phoneField, '123');
      await tester.pump();

      expect(find.text('El teléfono debe tener 10 números'), findsOneWidget);
    });
  });

  group('Empty fields', () {
    testWidgets('Form submission shows error when fields are empty', (
        WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Crear_cuenta()));

      await tester.tap(find.text('Crear cuenta'));
      await tester.pump();

      expect(
          find.text('Por favor, complete todos los campos.'), findsOneWidget);
    });
  });
}