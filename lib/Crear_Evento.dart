import 'package:event/Menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

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
  TextEditingController _precioAdultoController =
  TextEditingController(); // Controlador para el campo de texto del precio para adultos
  TextEditingController _precioNinoController =
  TextEditingController(); // Controlador para el campo de texto del precio para niños
  TextEditingController _precioSeniorController =
  TextEditingController(); // Controlador para el campo de texto del precio para seniors
  TextEditingController _descripcionController =
  TextEditingController(); // Controlador para el campo de texto de la descripción
  DateTime? _selectedStartDate; // Variable para almacenar la fecha de inicio seleccionada
  DateTime? _selectedEndDate; // Variable para almacenar la fecha de fin seleccionada
  TimeOfDay? _selectedStartTime; // Variable para almacenar la hora de inicio seleccionada
  TimeOfDay? _selectedEndTime; // Variable para almacenar la hora de fin seleccionada


  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Aquí puedes manejar la imagen seleccionada, como mostrarla en la interfaz de usuario o guardarla
      print('Imagen seleccionada: ${pickedImage.path}');
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 60,
                      ),
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
                      onTap: _selectImage, // Call _selectLocation instead of _selectImage
                      child: Image.asset('lib/pantallas/Agregar_Ubicacion.png',
                        width: 250,
                        height: 40,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Tipo()),
                        );
                      },
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