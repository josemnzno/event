import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:event/DetalleEvento.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:event/MisEventosComprados.dart';

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
  bool _puedeGuardar = true;

  Future<void> _guardarCompraFirestore() async {
    if (!_puedeGuardar) {
      return;
    }

    setState(() {
      _puedeGuardar = false;
    });

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Obtener el ID del usuario actual
      String? userId;
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid;
      } else {
        // El usuario no ha iniciado sesión, maneja este caso según tu lógica
      }

      // Guardar la compra en Firestore
      await firestore.collection('Boletos').add({
        'userId': userId, // ID del usuario que realizó la compra
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
      });

      // Regresar a la pantalla de MisEventosComprados después de guardar la compra
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MisEventosComprados(userId: userId ?? '')),
      );

      // Habilitar el botón de nuevo después de 10 minutos
      Timer(Duration(minutes: 10), () {
        setState(() {
          _puedeGuardar = true;
        });
      });
    } catch (error) {
      print('Error al guardar la compra en Firestore: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la compra: $error')),
      );
      setState(() {
        _puedeGuardar = true;
      });
    }
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
                    SizedBox(height: 70),
                    Text(
                      'Informacion \nde el evento',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 25),
                    _buildText('Evento: ${widget.evento.nombre}'),
                    _buildText('Descripción: ${widget.evento.descripcion}'),
                    _buildText('Inicio: ${DateFormat('dd/MM/yyyy').format(widget.evento.fechaInicio)} - ${widget.evento.horaInicio}'),
                    _buildText('Fin: ${DateFormat('dd/MM/yyyy').format(widget.evento.fechaFin)} - ${widget.evento.horaFin}'),
                    if (widget.cantidadAdultos > 0)
                      Text('Cantidad de Adultos: ${widget.cantidadAdultos}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    if (widget.cantidadNinos > 0)
                      Text('Cantidad de Niños: ${widget.cantidadNinos}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    if (widget.cantidadSeniors > 0)
                      Text('Cantidad de Seniors: ${widget.cantidadSeniors}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
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
                      onPressed: _puedeGuardar ? _guardarCompraFirestore : null,
                      child: Text('Guardar compra', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
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
