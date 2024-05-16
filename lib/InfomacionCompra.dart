import 'package:flutter/material.dart';
import 'package:event/DetalleEvento.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa cloud_firestore para interactuar con Firestore

class InformacionCompra extends StatefulWidget {
  final Evento evento;
  final String codigoBoleto;
  final double total;
  final int cantidadAdultos;
  final int cantidadNinos;
  final int cantidadSeniors;

  InformacionCompra({
    required this.total,
    required this.cantidadAdultos,
    required this.cantidadNinos,
    required this.cantidadSeniors,
    required this.evento,
    required this.codigoBoleto,
  });

  @override
  _InformacionCompraState createState() => _InformacionCompraState();
}

class _InformacionCompraState extends State<InformacionCompra> {

  // Función para guardar la información de la compra en Firebase
  void _guardarCompraFirestore() {
    // Accede a la instancia de Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Crea un nuevo documento con la información de la compra
    firestore.collection('Boletos').add({
      'nombreEvento': widget.evento.nombre,
      'descripcionEvento': widget.evento.descripcion,
      'inicioEvento': widget.evento.fechaInicio,
      'finEvento': widget.evento.fechaFin,
      'cantidadAdultos': widget.cantidadAdultos,
      'cantidadNinos': widget.cantidadNinos,
      'cantidadSeniors': widget.cantidadSeniors,
      'total': widget.total,
      'ubicacion': {
        'latitude': widget.evento.ubicacion.latitude,
        'longitude': widget.evento.ubicacion.longitude,
      },
      'codigoBoleto': widget.codigoBoleto,
    }).then((value) {
      print('Compra guardada en Firestore con ID: ${value.id}');
    }).catchError((error) {
      print('Error al guardar la compra en Firestore: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    String eventName = widget.evento.nombre;
    String eventDescription = widget.evento.descripcion;
    String eventDate = DateFormat('dd/MM/yyyy').format(widget.evento.fechaInicio);

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
                    SizedBox(height: 70,),
                    Text(
                      'Informacion \nde el evento',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 25),
                    _buildText('Evento: ${widget.evento.nombre}'),
                    _buildText('Descripción: ${widget.evento.descripcion}'),
                    _buildText('Inicio: ${DateFormat('dd/MM/yyyy').format(widget.evento.fechaInicio)} - ${widget.evento.horaInicio}'),
                    _buildText('Fin: ${DateFormat('dd/MM/yyyy').format(widget.evento.fechaFin)} - ${widget.evento.horaFin} '),

                    if (widget.cantidadAdultos > 0) Text('Cantidad de Adultos: ${widget.cantidadAdultos}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    if (widget.cantidadNinos > 0) Text('Cantidad de Niños: ${widget.cantidadNinos}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    if (widget.cantidadSeniors > 0) Text('Cantidad de Seniors: ${widget.cantidadSeniors}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Text('Total: \$${widget.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    Container(
                      height: 300,
                      width: 400,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(widget.evento.ubicacion.latitude, widget.evento.ubicacion.longitude),
                          zoom: 15,
                        ),
                        markers: Set.of([
                          Marker(
                            markerId: MarkerId('eventoLocation'),
                            position: LatLng(widget.evento.ubicacion.latitude, widget.evento.ubicacion.longitude),
                            infoWindow: InfoWindow(title: 'Ubicación del evento'),
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildText('Codigo QR de tu Boleto\n!No lo compartas!'),

                    QrImageView(
                      data: widget.codigoBoleto,
                      version: QrVersions.auto,
                      size: 200,
                    ),
                    Text(
                      widget.codigoBoleto,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: _guardarCompraFirestore, // Llama a la función para guardar la compra en Firestore
                      child: Text('Guardar compra en Firestore', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
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
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}
