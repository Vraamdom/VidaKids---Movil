import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menu_footer.dart'; // Importa el footer

class CitasPage extends StatefulWidget {
  @override
  _CitasPageState createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _citas = {};
  int _selectedIndex = 0; // Índice para la página de Citas

  @override
  void initState() {
    super.initState();
    _fetchCitas();
  }

  Future<void> _fetchCitas() async {
    final response = await http.get(Uri.parse('http://localhost:8000/citas'));

    if (response.statusCode == 200) {
      List citas = json.decode(response.body);
      Map<DateTime, List<dynamic>> citasMap = {};

      for (var cita in citas) {
        DateTime fecha = DateTime.parse(cita['fecha_inicio_cita']);
        DateTime fechaInicio = DateTime(fecha.year, fecha.month, fecha.day);
        if (!citasMap.containsKey(fechaInicio)) {
          citasMap[fechaInicio] = [];
        }
        citasMap[fechaInicio]?.add(cita);
      }

      setState(() {
        _citas = citasMap;
      });
    } else {
      throw Exception('Failed to load citas');
    }
  }

  List<dynamic> _getCitasForDay(DateTime day) {
    DateTime dateKey = DateTime(day.year, day.month, day.day);
    return _citas[dateKey] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Citas',
          style: TextStyle(
            color: Colors.white, // Texto del título en blanco
            fontWeight: FontWeight.bold, // Texto en negrita
          ),
        ),
        backgroundColor: Colors.lightBlue, // Mismo color de fondo que en eventos
        centerTitle: true, // Centrar el título
        automaticallyImplyLeading: false, // Oculta la flecha de retroceso
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            eventLoader: _getCitasForDay,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: _getCitasForDay(_selectedDay ?? _focusedDay).length,
              itemBuilder: (context, index) {
                var cita = _getCitasForDay(_selectedDay ?? _focusedDay)[index];
                return ListTile(
                  title: Text('Cita con: ${cita['profesional_eps']}'),
                  subtitle: Text('Estado: ${cita['estado_cita']}'),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: MenuFooter(
        currentIndex: _selectedIndex, // Asigna el índice de la página de Citas
      ),
    );
  }
}
