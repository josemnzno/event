// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/DetalleEvento.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:event/main.dart';

void main() {
  testWidgets('DetalleEvento Widget Test', (WidgetTester tester) async {
    final sampleEvent = {
      'nombre': 'Sample Event',
      'descripcion': 'Sample description',
      'fechaInicio': Timestamp.fromDate(DateTime.now()),
      'fechaFin': Timestamp.fromDate(DateTime.now().add(Duration(days: 1))),
      'horaInicio': '10:00 AM',
      'horaFin': '12:00 PM',
      'precioAdulto': 100.0,
      'precioNino': 50.0,
      'precioSenior': 70.0,
    };

    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: DetalleEvento(),
    ));

    // Verify that the information is displayed correctly
    expect(find.text('Informacion'), findsOneWidget);
    expect(find.text('Evento: Sample Event'), findsOneWidget);
    expect(find.text('Descripción: Sample description'), findsOneWidget);
    expect(find.text('Inicio:'), findsOneWidget);
    expect(find.text('Fin:'), findsOneWidget);
    expect(find.text('Precio Adulto: \$10.0'), findsOneWidget);
    expect(find.text('Precio Niño: \$5.0'), findsOneWidget);
    expect(find.text('Precio Senior: \$7.0'), findsOneWidget);
  });
  }
}