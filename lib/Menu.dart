import 'package:event/Crear_Evento.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Tipo extends StatefulWidget {
  const Tipo({Key? key}) : super(key: key);

  @override
  _TipoState createState() => _TipoState();
}

class _TipoState extends State<Tipo> {
  TextEditingController _searchController = TextEditingController();
  List<String> _events = [
    'Evento 1',
    'Evento 2',
    'Evento 3',
    'Otro evento 1',
    'Otro evento 2',
    'Otro evento 3',
  ];
  List<String> _filteredEvents = [];
  String _nombreUsuario = ""; // Variable para almacenar el nombre del usuario

  @override
  void initState() {
    super.initState();
    _filteredEvents.addAll(_events);
    _getUserDisplayName(); // Obtener el nombre del usuario al iniciar la aplicación
  }

  void _filterEvents(String searchText) {
    setState(() {
      _filteredEvents = _events
          .where((event) =>
          event.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<void> _getUserDisplayName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _nombreUsuario = user.displayName ?? ""; // Obtener el nombre del usuario
      });
    }
  }

  void _showUserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Mi cuenta'),
                onTap: () {
                  // Acción al seleccionar "Mi cuenta"
                },
              ),
              ListTile(
                title: Text('Cerrar sesión'),
                onTap: () {
                  // Acción al seleccionar cerrar sesión
                },
              ),
            ],
          ),
        );
      },
    );
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
                      'EventApp',
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                              ),
                              onChanged: _filterEvents,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Crear_Evento(usuario: FirebaseAuth.instance.currentUser),
                          ),
                        );

                      },
                      child: Image.asset(
                        'lib/pantallas/Crear_Evento.png',
                        width: 220,
                      ),
                    ),
                    SizedBox(
                        height:
                        10), // Añadido espacio entre el botón y el cuadro "Eventos"
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
                    // Espacio adicional entre el botón y el ListView
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredEvents.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(_filteredEvents[index]),
                              onTap: () {
                                // Acción al hacer clic en el evento
                              },
                            ),
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
                  icon: Icon(Icons.account_circle,
                      size: 40), // Icono de usuario más grande
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
