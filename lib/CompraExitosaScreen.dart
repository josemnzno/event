import 'package:event/InfomacionCompra.dart';
import 'package:flutter/material.dart';
import 'package:event/DetalleEvento.dart'; // Importa la clase Evento
import 'package:intl/intl.dart'; // Importa DateFormat
import 'package:uuid/uuid.dart'; // Importa la librería uuid para generar ID único
class CompraExitosaScreen extends StatelessWidget {
  final Evento evento; // Objeto Evento en lugar de Map<String, dynamic>
  final String codigoBoleto; // Define el parámetro codigoBoleto

  final double total;
  final int cantidadAdultos;
  final int cantidadNinos;
  final int cantidadSeniors;

  CompraExitosaScreen({
    required this.total,
    required this.cantidadAdultos,
    required this.cantidadNinos,
    required this.cantidadSeniors,
    required this.evento, // Ajusta el parámetro para aceptar un objeto Evento
    required this.codigoBoleto, // Agrega el parámetro codigoBoleto
  });

  @override
  Widget build(BuildContext context) {
    // Accede a las propiedades del objeto evento directamente
    String eventName = evento.nombre;
    String eventDescription = evento.descripcion;
    String eventDate = DateFormat('dd/MM/yyyy').format(evento.fechaInicio);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/pantallas/fondo2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100,),
                    Text(
                      'Compra Exitosa',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 25),
                    Text('Evento: $eventName', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Text('Descripción: $eventDescription', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal,),textAlign: TextAlign.center),
                    Text('Fecha: $eventDate', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Text('Cantidad de Adultos: $cantidadAdultos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Text('Cantidad de Niños: $cantidadNinos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Text('Cantidad de Seniors: $cantidadSeniors', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Text('Total: \$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InformacionCompra(
                            total: total,
                            cantidadAdultos: cantidadAdultos,
                            cantidadNinos: cantidadNinos,
                            cantidadSeniors: cantidadSeniors,
                            evento: evento, // Pasa el objeto Evento
                            codigoBoleto: codigoBoleto, // Pasa el ID único de la compra
                          )),
                        );
                      },
                      child: Text('ver informacion de la compra', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    ),

                    // Muestra el código QR basado en el ID único de la compra
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
