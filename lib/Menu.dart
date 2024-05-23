import 'package:event/Crear_Evento.dart';
import 'package:event/Cuenta.dart';
import 'package:event/DetalleEvento.dart';
import 'package:event/Inicio.dart';
import 'package:event/MisEventosComprados.dart';
import 'package:event/ValidacionBoleto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'MisEventos.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({Key? key}) : super(key: key);

  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  TextEditingController _searchController = TextEditingController();
  String _nombreUsuario = "";

  @override
  void initState() {
    super.initState();
    _getUserDisplayName();
  }

  Future<void> _getUserDisplayName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _nombreUsuario = user.displayName ?? "";
      });
    }
  }

  void _showUserMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 0), // Posición del menú
      items: [
        PopupMenuItem(
          value: 'cuenta',
          child: Text('Cuenta'),
        ),
        PopupMenuItem(
          value: 'compras',
          child: Text('Mis Compras'),
        ),
        PopupMenuItem(
          value: 'eventos',
          child: Text('Mis Eventos'),
        ),
        PopupMenuItem(
          value: 'validar_boleto',
          child: Text('Validar Boleto'), // Nueva opción para validar boleto
        ),
        PopupMenuItem(
          value: 'cerrar_sesion',
          child: Text('Cerrar Sesión'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'cuenta':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CuentaScreen()),
            );
            break;
          case 'compras':
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MisEventosComprados(userId: user.uid),
                ),
              );
            }
            break;
          case 'eventos':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventosCreadosScreen()),
            );
            break;
          case 'validar_boleto':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QRScanScreen(),
              ),
            );
            break;
          case 'cerrar_sesion':
            FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Inicio()),
                  (route) => false,
            );
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/pantallas/fondo2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 70),
                    Text(
                      'EcoTicket',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                hintText: 'Buscar evento',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              ),
                              onChanged: _filterEvents,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        // Espera a que se complete la creación del evento
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Crear_Evento(
                              usuario: FirebaseAuth.instance.currentUser,
                            ),
                          ),
                        );

                        // Actualiza la lista de eventos después de crear un evento
                        setState(() {}); // Forzar la reconstrucción del widget para actualizar la lista
                      },
                      child: Image.asset(
                        'lib/pantallas/Crear_Evento.png',
                        width: 220,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Eventos',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('Eventos').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se espera la respuesta de Firestore
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          // Filtra los eventos si hay un texto de búsqueda
                          List<QueryDocumentSnapshot> filteredEventos = snapshot.data!.docs.where((evento) {
                            String nombreEvento = evento['nombre'].toString().toLowerCase();
                            return nombreEvento.contains(_searchController.text.toLowerCase());
                          }).toList();
                          return ListView.builder(
                            itemCount: filteredEventos.length,
                            itemBuilder: (context, index) {
                              var evento = filteredEventos[index];
                              var fechaInicio = DateFormat('dd/MM/yyyy').format(evento['fechaInicio'].toDate());
                              return Card(
                                color: Colors.greenAccent[100],
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        evento['nombre'].toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        fechaInicio,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetalleEvento(evento: evento),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _nombreUsuario,
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  onPressed: () {
                    _showUserMenu(context);
                  },
                  icon: Icon(Icons.account_circle, size: 40),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _filterEvents(String searchText) {
    setState(() {
      // No es necesario filtrar aquí ya que el StreamBuilder lo hace automáticamente
    });
  }
}
