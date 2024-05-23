import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetalleEventoComprado extends StatelessWidget {
  final DocumentSnapshot evento;

  DetalleEventoComprado({required this.evento});

  @override
  Widget build(BuildContext context) {
    final nombreEvento = evento['nombreEvento'];
    final descripcionEvento = evento['descripcionEvento'] ?? 'No hay descripción disponible';
    final inicioEvento = evento['inicioEvento'] as Timestamp;
    final finEvento = evento['finEvento'] as Timestamp;
    final cantidadAdultos = evento['cantidadAdultos'];
    final cantidadNinos = evento['cantidadNinos'];
    final cantidadSeniors = evento['cantidadSeniors'];
    final total = evento['total'];
    final codigoBoleto = evento['codigoBoleto'];
    final ubicacion = evento['ubicacion'];
    final formattedInicioEvento = DateFormat('dd/MM/yyyy').format(inicioEvento.toDate());
    final formattedFinEvento = DateFormat('dd/MM/yyyy').format(finEvento.toDate());

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
                    SizedBox(height: 70),
                    Text(
                      'Información del evento',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    _buildText('Evento: $nombreEvento'),
                    _buildText('Descripción: $descripcionEvento'),
                    _buildText('Inicio: $formattedInicioEvento'),
                    _buildText('Fin: $formattedFinEvento'),
                    if (cantidadAdultos > 0)
                      Text('Cantidad de Adultos: $cantidadAdultos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    if (cantidadNinos > 0)
                      Text('Cantidad de Niños: $cantidadNinos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    if (cantidadSeniors > 0)
                      Text('Cantidad de Seniors: $cantidadSeniors', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Text('Total: \$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Container(
                      height: 300,
                      width: 400,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(ubicacion['latitude'], ubicacion['longitude']),
                          zoom: 15,
                        ),
                        markers: Set.of([
                          Marker(
                            markerId: MarkerId('eventoLocation'),
                            position: LatLng(ubicacion['latitude'], ubicacion['longitude']),
                            infoWindow: InfoWindow(title: 'Ubicación del evento'),
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildText('Codigo QR de tu Boleto\n¡No lo compartas!'),
                    QrImageView(
                      data: codigoBoleto,
                      version: QrVersions.auto,
                      size: 200,
                    ),
                    Text(
                      codigoBoleto,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

  Widget _buildText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}
