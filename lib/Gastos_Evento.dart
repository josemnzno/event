import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Gastos_Evento extends StatefulWidget {
  const Gastos_Evento({Key? key}) : super(key: key);

  @override
  _Gastos_EventoState createState() => _Gastos_EventoState();
}

class _Gastos_EventoState extends State<Gastos_Evento> {
  Map<String, double> _gastos = {
    'Food': 500,
    'Transportation': 200,
    'Accommodation': 800,
    'Miscellaneous': 300,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: EventExpenses(gastos: _gastos, updateGastos: _updateGastos),
      ),
    );
  }

  void _updateGastos(Map<String, double> newGastos) {
    setState(() {
      _gastos = newGastos;
    });
  }
}

class EventExpenses extends StatelessWidget {
  final Map<String, double> gastos;
  final Function(Map<String, double>) updateGastos;

  const EventExpenses({Key? key, required this.gastos, required this.updateGastos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/pantallas/fondo.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 250),
          Text(
            'ESTADISTICAS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 75),
          Expanded(
            child: ListView.builder(
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                final category = gastos.keys.elementAt(index);
                final amount = gastos.values.elementAt(index);
                return ListTile(
                  title: Text(category),
                  trailing: Text('\$$amount'),
                );
              },
            ),
          ),
          SizedBox(height: 20), // Space between list and chart
          Container(
            height: 200,
            padding: EdgeInsets.all(16),
            child: SfCircularChart(
              series: <CircularSeries>[
                PieSeries<Gasto, String>(
                  dataSource: _createSeries(gastos),
                  xValueMapper: (Gasto gasto, _) => gasto.categoria,
                  yValueMapper: (Gasto gasto, _) => gasto.monto,
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          GestureDetector(
            onTap: () {
              // Add expense logic here
              Map<String, double> updatedGastos = Map.from(gastos);
              updatedGastos['New Expense'] = 100; // Example: Add a new expense
              updateGastos(updatedGastos);
            },
            child: Image.asset(
              'lib/pantallas/Start.png', // Ruta de la imagen a utilizar
              width: 175, // Ancho de la imagen
              height: 175, // Alto de la imagen
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //Add expense
                  },
                  child: Text('Agregar gasto'),
                ),
                ElevatedButton(
                  onPressed: () {
                    //Download expense report
                  },
                  child: Text('Descargar reporte de gastos'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Gasto> _createSeries(Map<String, double> gastos) {
    return gastos.entries
        .map((entry) => Gasto(entry.key, entry.value))
        .toList();
  }
}

class Gasto {
  final String categoria;
  final double monto;

  Gasto(this.categoria, this.monto);
}