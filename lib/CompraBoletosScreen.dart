import 'package:flutter/material.dart';
import 'package:event/DetalleEvento.dart'; // Importa la clase Evento
import 'package:event/CompraExitosaScreen.dart'; // Importa la pantalla de compra exitosa
import 'package:intl/intl.dart'; // Importa DateFormat
import 'package:uuid/uuid.dart'; // Importa la librería uuid para generar ID único

class DetalleCompraScreen extends StatelessWidget {
  final double total;
  final int cantidadAdultos;
  final int cantidadNinos;
  final int cantidadSeniors;
  final Evento evento;
  final int boletosDisponibles;

  const DetalleCompraScreen({
    Key? key,
    required this.total,
    required this.cantidadAdultos,
    required this.cantidadNinos,
    required this.cantidadSeniors,
    required this.evento,
    required this.boletosDisponibles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Genera un ID único para la compra del boleto
    String codigoBoleto = Uuid().v4();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/pantallas/fondo2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Detalle de la Compra',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 25),
                  Text('Nombre del Evento: ${evento.nombre}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                  Text('Descripción del Evento: ${evento.descripcion}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal), textAlign: TextAlign.center),
                  Text('Fecha del Evento: ${DateFormat('dd/MM/yyyy').format(evento.fechaInicio)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
                  Text('Cantidad de Adultos: $cantidadAdultos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                  Text('Cantidad de Niños: $cantidadNinos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                  Text('Cantidad de Seniors: $cantidadSeniors', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                  Text('Total: \$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CompraExitosaScreen(
                          total: total,
                          cantidadAdultos: cantidadAdultos,
                          cantidadNinos: cantidadNinos,
                          cantidadSeniors: cantidadSeniors,
                          evento: evento,
                          codigoBoleto: codigoBoleto, // Pasa el ID único de la compra
                        )),
                      );
                    },
                    child: Text('Pagar con Mercado Libre', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompraExitosaScreen(
                            total: total,
                            cantidadAdultos: cantidadAdultos,
                            cantidadNinos: cantidadNinos,
                            cantidadSeniors: cantidadSeniors,
                            evento: evento,
                            codigoBoleto: codigoBoleto, // Pasa el ID único de la compra
                          ),
                        ),
                      );
                    },
                    child: Text('Pagar con PayPal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
