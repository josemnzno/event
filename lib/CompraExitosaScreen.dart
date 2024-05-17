import 'package:flutter/material.dart';
import 'package:event/DetalleEvento.dart'; // Importa la clase Evento
import 'package:cloud_firestore/cloud_firestore.dart';

import 'InfomacionCompra.dart'; // Importa Firestore

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
                    Text('Evento: ${evento.nombre}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Text('Descripción: ${evento.descripcion}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal,),textAlign: TextAlign.center),
                    Text('Cantidad de Adultos: $cantidadAdultos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Text('Cantidad de Niños: $cantidadNinos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Text('Cantidad de Seniors: $cantidadSeniors', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Text('Total: \$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Actualizar el campo "boletosDisponibles" en Firestore
                        FirebaseFirestore.instance
                            .collection('Eventos')
                            .where('nombre', isEqualTo: evento.nombre)
                            .get()
                            .then((querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            // Si se encuentra un evento con el mismo nombre
                            final eventoDoc = querySnapshot.docs.first;
                            final boletosDisponiblesActual = eventoDoc['boletosDisponibles'];
                            final nuevosBoletosDisponibles = boletosDisponiblesActual - (cantidadAdultos + cantidadNinos + cantidadSeniors);
                            eventoDoc.reference.update({'boletosDisponibles': nuevosBoletosDisponibles})
                                .then((_) {
                              // Navegar a la pantalla de información de la compra
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InformacionCompra(
                                    total: total,
                                    cantidadAdultos: cantidadAdultos,
                                    cantidadNinos: cantidadNinos,
                                    cantidadSeniors: cantidadSeniors,
                                    evento: evento, // Pasa el objeto Evento
                                    codigoBoleto: codigoBoleto, // Pasa el ID único de la compra
                                  ),
                                ),
                              );
                            })
                                .catchError((error) {
                              // Manejar errores si la actualización falla
                              print('Error al actualizar los boletos disponibles: $error');
                            });
                          } else {
                            print('No se encontró ningún evento con el nombre: ${evento.nombre}');
                          }
                        })
                            .catchError((error) {
                          // Manejar errores si la consulta falla
                          print('Error al buscar el evento: $error');
                        });
                      },
                      child: Text('Guardar Compra', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
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
