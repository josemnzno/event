import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class EstadisticasEvento extends StatelessWidget {
  final QueryDocumentSnapshot evento;

  const EstadisticasEvento({Key? key, required this.evento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estadísticas del Evento'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _obtenerEstadisticas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos disponibles'));
          }

          final estadisticas = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Boletos Vendidos: ${estadisticas['boletosVendidos']}'),
                Text('Boletos Totales: ${estadisticas['boletosTotales']}'),
                Text('Boletos de Niño Vendidos: ${estadisticas['boletosNino']}'),
                Text('Boletos de Adulto Vendidos: ${estadisticas['boletosAdulto']}'),
                Text('Boletos de Senior Vendidos: ${estadisticas['boletosSenior']}'),
                Text('Total Vendido: ${estadisticas['totalVendido']}'),
                _buildGraficaPastel(estadisticas),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _obtenerEstadisticas() async {
    int boletosVendidos = 0;
    int boletosTotales = 0;
    int boletosNino = 0;
    int boletosAdulto = 0;
    int boletosSenior = 0;
    double totalVendido = 0.0;

    // Obtener los datos del documento del evento
    Map<String, dynamic> data = evento.data() as Map<String, dynamic>;

    // Obtener los valores de los boletos y el total vendido
    boletosVendidos = data['cantidadAdultos'] + data['cantidadNinos'] + data['cantidadSeniors'];
    boletosTotales = data['boletosTotales'];
    boletosNino = data['cantidadNinos'];
    boletosAdulto = data['cantidadAdultos'];
    boletosSenior = data['cantidadSeniors'];
    totalVendido = (data['cantidadAdultos'] * data['precioAdulto']) +
        (data['cantidadNinos'] * data['precioNino']) +
        (data['cantidadSeniors'] * data['precioSenior']);

    return {
      'boletosVendidos': boletosVendidos,
      'boletosTotales': boletosTotales,
      'boletosNino': boletosNino,
      'boletosAdulto': boletosAdulto,
      'boletosSenior': boletosSenior,
      'totalVendido': totalVendido,
    };
  }

  Widget _buildGraficaPastel(Map<String, dynamic> estadisticas) {
    final data = [
      GraficaData('Niño', estadisticas['boletosNino'] ?? 0, Colors.blue),
      GraficaData('Adulto', estadisticas['boletosAdulto'] ?? 0, Colors.red),
      GraficaData('Senior', estadisticas['boletosSenior'] ?? 0, Colors.green),
    ];

    final series = [
      charts.Series<GraficaData, String>(
        id: 'Boletos Vendidos',
        domainFn: (GraficaData data, _) => data.categoria,
        measureFn: (GraficaData data, _) => data.cantidad,
        colorFn: (GraficaData data, _) => charts.ColorUtil.fromDartColor(data.color),
        data: data,
      ),
    ];

    return SizedBox(
      height: 400,
      child: charts.PieChart(
        series,
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(
          arcWidth: 100,
          arcRendererDecorators: [
            charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.inside,
            ),
          ],
        ),
      ),
    );
  }
}

class GraficaData {
  final String categoria;
  final int cantidad;
  final Color color;

  GraficaData(this.categoria, this.cantidad, this.color);
}
