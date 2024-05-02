import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Seleccionar_Ubicacion.dart';

class Crear_Evento extends StatefulWidget {
  final User? usuario;

  const Crear_Evento({Key? key, this.usuario}) : super(key: key);

  @override
  _Crear_EventoState createState() => _Crear_EventoState();
}

final firebase = FirebaseFirestore.instance;

class _Crear_EventoState extends State<Crear_Evento> {
  TextEditingController _nombreEventoController = TextEditingController();
  TextEditingController _boletosDisponiblesController = TextEditingController();
  TextEditingController _precioAdultoController = TextEditingController();
  TextEditingController _precioNinoController = TextEditingController();
  TextEditingController _precioSeniorController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  File? _selectedImage;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final String hour = timeOfDay.hour.toString().padLeft(2, '0');
    final String minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _guardarEvento() async {
    try {
      String imageUrl = await _uploadImageToStorage();
      String horaInicio = _selectedStartTime != null ? _formatTimeOfDay(_selectedStartTime!) : '';
      String horaFin = _selectedEndTime != null ? _formatTimeOfDay(_selectedEndTime!) : '';

      await firebase.collection('Eventos').add({
        'usuarioId': widget.usuario?.uid,
        'nombre': _nombreEventoController.text,
        'boletosDisponibles': int.parse(_boletosDisponiblesController.text),
        'precioAdulto': double.parse(_precioAdultoController.text),
        'precioNino': double.parse(_precioNinoController.text),
        'precioSenior': double.parse(_precioSeniorController.text),
        'descripcion': _descripcionController.text,
        'fechaInicio': _selectedStartDate,
        'fechaFin': _selectedEndDate,
        'horaInicio': horaInicio,
        'horaFin': horaFin,
        'imagenUrl': imageUrl,
      });

      // Mostrar el cuadro de diálogo de evento creado exitoso
      _mostrarDialogoEventoCreado();
    } catch (e) {
      print('Error al guardar el evento: $e');
    }
  }


  Future<String> _uploadImageToStorage() async {
    try {
      if (_selectedImage != null) {
        Reference ref = FirebaseStorage.instance.ref().child('Eventos').child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        UploadTask uploadTask = ref.putFile(_selectedImage!);
        await uploadTask.whenComplete(() => null);
        String imageUrl = await ref.getDownloadURL();
        return imageUrl;
      } else {
        return '';
      }
    } catch (e) {
      print('Error al subir la imagen: $e');
      return '';
    }
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
                    SizedBox(height: 50),
                    Text(
                      'Crear Evento',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Row(
                        children: [
                          Text(
                            'Nombre:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            width: 5,
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
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            'Empieza:   ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(width: 5),
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
                          SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () async {
                              final selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (selectedTime != null) {
                                setState(() {
                                  _selectedStartTime = selectedTime;
                                });
                              }
                            },
                            child: Text(
                              _selectedStartTime != null
                                  ? '${_selectedStartTime!.hour}:${_selectedStartTime!.minute}'
                                  : 'Hora',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            'Termina:   ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(width: 5),
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
                                  _selectedEndDate = selectedDate;
                                });
                              }
                            },
                            child: Text(
                              _selectedEndDate != null
                                  ? '${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}'
                                  : 'Dia',
                            ),
                          ),
                          SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () async {
                              final selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (selectedTime != null) {
                                setState(() {
                                  _selectedEndTime = selectedTime;
                                });
                              }
                            },
                            child: Text(
                              _selectedEndTime != null
                                  ? '${_selectedEndTime!.hour}:${_selectedEndTime!.minute}'
                                  : 'Hora',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Boletos\nDisponibles:',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: _boletosDisponiblesController,
                                  style: TextStyle(fontSize: 15),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}')),
                                  ], // Acepta solo números
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '"1000"',
                                    filled: true,
                                    fillColor: Colors.greenAccent[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Precio \nBoletos:',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _precioAdultoController,
                                        style: TextStyle(fontSize: 12),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Adultos',
                                          filled: true,
                                          fillColor: Colors.greenAccent[100],
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _precioNinoController,
                                        style: TextStyle(fontSize: 12),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Niños',
                                          filled: true,
                                          fillColor: Colors.greenAccent[100],
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _precioSeniorController,
                                        style: TextStyle(fontSize: 12),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Senior',
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Descripción:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _descripcionController,
                            style: TextStyle(fontSize: 15),
                            maxLines: 5, // Limita a 6 líneas
                            keyboardType: TextInputType.multiline,
                            maxLength: 250, // Límite de caracteres
                            decoration: InputDecoration(
                              hintText: 'Agrega una descripción',
                              filled: true,
                              fillColor: Colors.greenAccent[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _selectImage,
                      child: Image.asset(
                        'lib/pantallas/Agregar_Imagen.png',
                        width: 250,
                        height: 40,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen()),
                        );
                      },
                      child: Image.asset(
                        'lib/pantallas/Agregar_Ubicacion.png',
                        width: 250,
                        height: 40,
                      ),
                    ),
                    GestureDetector(
                      onTap: _guardarEvento,
                      child: Image.asset(
                        'lib/pantallas/Crear_Evento.png',
                        width: 230,
                        height: 65,
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
  void _mostrarDialogoEventoCreado() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Evento creado con éxito"),
          content: Text("El evento se ha guardado correctamente."),
          actions: [
            TextButton(
              onPressed: () {
                // Cerrar el cuadro de diálogo
                Navigator.of(context).pop();
                // Regresar a la pantalla del menú
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _nombreEventoController.dispose();
    _boletosDisponiblesController.dispose();
    _precioAdultoController.dispose();
    _precioNinoController.dispose();
    _precioSeniorController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }
}
