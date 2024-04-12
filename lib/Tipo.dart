import 'package:event/Crear_Evento.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _filteredEvents.addAll(_events);
  }

  void _filterEvents(String searchText) {
    setState(() {
      _filteredEvents = _events
          .where((event) =>
          event.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/pantallas/Pantalla_Eventos.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 110),
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                                contentPadding:
                                EdgeInsets.symmetric(
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
                          MaterialPageRoute(builder: (context) =>
                              Crear_Evento()),
                        );
                      },
                      child: Image.asset(
                        'lib/pantallas/Crear_Evento.png',
                        width: 250,
                      ),
                    ),
                    SizedBox(height: 40),
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
            child: Container(
              width: 50, // Tamaño personalizado
              height: 50, // Tamaño personalizado
              child: IconButton(
                onPressed: () {
                  // Acción al hacer clic en el icono de usuario
                },
                icon: Icon(Icons.account_circle,
                    size: 40), // Icono de usuario más grande
              ),
            ),
          ),
        ],
      ),
    );
  }
}
