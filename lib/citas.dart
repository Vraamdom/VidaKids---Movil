import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Para manejar la localización
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
    initializeDateFormatting('es_ES', null).then((_) => _fetchCitas()); // Inicializamos la traducción a español
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
      body: TableCalendar(
        locale: 'es_ES', // Traducción al español
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        shouldFillViewport: true, // Hace que el calendario ocupe todo el espacio vertical
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (_getCitasForDay(selectedDay).isNotEmpty) {
            Navigator.pushNamed(
              context,
              '/citas_del_dia',
              arguments: {
                'fecha': selectedDay,
                'citas': _getCitasForDay(selectedDay),
              },
            );
          }
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        eventLoader: _getCitasForDay, // Carga de eventos para mostrar las bolitas
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
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.lightBlue, // Color para el círculo del día actual
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Color.fromARGB(255, 140, 212, 245), // Color para el círculo del día seleccionado
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Colors.lightBlue, // Color para los marcadores de citas (bolitas)
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3, // Máximo número de marcadores (bolitas)
          outsideDaysVisible: false,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          weekendStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        headerStyle: HeaderStyle(
          titleTextFormatter: (date, locale) {
            return DateFormat('MMMM yyyy', locale).format(date).toUpperCase();
          },
          formatButtonVisible: false,
        ),
      ),
      bottomNavigationBar: MenuFooter(
        currentIndex: _selectedIndex, // Asigna el índice de la página de Citas
      ),
    );
  }
}
