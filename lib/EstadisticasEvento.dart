import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'MisEventosDetalles.dart';

class EstadisticasEventos extends StatefulWidget {
  final MisEvento evento;

  const EstadisticasEventos({Key? key, required this.evento}) : super(key: key);

  @override
  _EstadisticasEventosState createState() => _EstadisticasEventosState();
}

class _EstadisticasEventosState extends State<EstadisticasEventos> {
  User? user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  void _fetchUser() {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de pantalla
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/pantallas/fondo2.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Text(
                          'Estadísticas\ndel Evento',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        _buildText('Boletos Totales: ${widget.evento.boletosTotales}'),
                        _buildText('Lugares Restantes: ${widget.evento.boletosDisponibles}'),
                        _buildText('Boletos Vendidos: ${widget.evento.boletosTotales - widget.evento.boletosDisponibles}'),
                        _buildText('boletos de niños vendidos: ${widget.evento.boletosNinosVendidos}'),
                        _buildText('boletos de adultos vendidos: ${widget.evento.boletosAdultosVendidos}'),
                        _buildText('boletos de senior vendidos: ${widget.evento.boletosSeniorsVendidos}'),


                        _buildText('Ganancias: \$${_calcularGanancias()}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calcularGanancias() {
    return (widget.evento.boletosTotales - widget.evento.boletosDisponibles) *
        ((widget.evento.precioAdulto + widget.evento.precioNino + widget.evento.precioSenior) / 3);
  }

  Widget _buildText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}
