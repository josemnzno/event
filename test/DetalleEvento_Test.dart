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
import 'package:intl/src/intl/date_format.dart';

import 'package:event/main.dart';

void main() {
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

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
      'ubicacion': GeoPoint(37.7749, -122.4194),
    };

    await tester.pumpWidget(MaterialApp(
      home: DetalleEvento(evento: sampleEvent),
    ));

    expect(find.text('Informacion'), findsOneWidget);
    expect(find.text('Evento: Sample Event'), findsOneWidget);
    expect(find.text('Descripción: Sample description'), findsOneWidget);
    expect(find.text('Inicio: ${dateFormat.format((sampleEvent['fechaInicio'] as Timestamp).toDate())} - ${sampleEvent['horaInicio']}'), findsOneWidget);
    expect(find.text('Fin: ${dateFormat.format((sampleEvent['fechaFin'] as Timestamp).toDate())} - ${sampleEvent['horaFin']}'), findsOneWidget);
    expect(find.text('Precio Adulto: \$100.0'), findsOneWidget);
    expect(find.text('Precio Niño: \$50.0'), findsOneWidget);
    expect(find.text('Precio Senior: \$70.0'), findsOneWidget);
  });
}