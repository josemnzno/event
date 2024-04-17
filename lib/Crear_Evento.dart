import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa este paquete para utilizar FilteringTextInputFormatter

class Crear_Evento extends StatefulWidget {
  const Crear_Evento({Key? key}) : super(key: key);

  @override
  _Crear_EventoState createState() => _Crear_EventoState();
}

class _Crear_EventoState extends State<Crear_Evento> {
  TextEditingController _nombreEventoController =
  TextEditingController(); // Controlador para el campo de texto del nombre del evento
  TextEditingController _boletosDisponiblesController =
  TextEditingController(); // Controlador para el campo de texto de boletos disponibles
  DateTime? _selectedStartDate; // Variable para almacenar la fecha de inicio seleccionada
  DateTime? _selectedEndDate; // Variable para almacenar la fecha de fin seleccionada
  TimeOfDay? _selectedTime; // Variable para almacenar la hora seleccionada

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
                    SizedBox(height: 80),
                    Text(
                      'Crear Evento',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 60,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Nombre:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _nombreEventoController,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                hintText: 'ejemplo "xv rubi"',
                                filled: true,
                                fillColor: Colors.greenAccent[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Empieza:   ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _selectedStartDate = selectedDate;
                                });
                              }
                            },
                            child: Text(
                              _selectedStartDate != null
                                  ? '${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}'
                                  : 'Dia',
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (selectedTime != null) {
                                setState(() {
                                  _selectedTime = selectedTime;
                                });
                              }
                            },
                            child: Text(
                              _selectedTime != null
                                  ? '${_selectedTime!.hour}:${_selectedTime!.minute}'
                                  : 'Hora',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Termina:   ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _selectedStartDate = selectedDate;
                                });
                              }
                            },
                            child: Text(
                              _selectedStartDate != null
                                  ? '${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}'
                                  : 'Dia',
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (selectedTime != null) {
                                setState(() {
                                  _selectedTime = selectedTime;
                                });
                              }
                            },
                            child: Text(
                              _selectedTime != null
                                  ? '${_selectedTime!.hour}:${_selectedTime!.minute}'
                                  : 'Hora',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30, // Ajusta el espacio horizontal aquí
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Boletos Disponibles:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _boletosDisponiblesController,
                              style: TextStyle(fontSize: 15),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ], // Acepta solo números
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'ejemplo "100"',
                                filled: true,
                                fillColor: Colors.greenAccent[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  @override
  void dispose() {
    _nombreEventoController.dispose();
    _boletosDisponiblesController.dispose();
    super.dispose();
  }
}
