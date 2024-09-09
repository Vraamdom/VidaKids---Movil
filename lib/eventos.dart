import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menu_footer.dart'; // Importa el footer

class EventosPage extends StatefulWidget {
  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _eventos = {};
  int _selectedIndex = 1; // Índice para la página de Eventos

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null).then((_) => _fetchEventos()); // Inicializamos la traducción a español
  }

  Future<void> _fetchEventos() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/eventos'));

      if (response.statusCode == 200) {
        List eventos = json.decode(response.body);
        Map<DateTime, List<dynamic>> eventosMap = {};

        for (var evento in eventos) {
          if (evento['fecha_hora_inicial_evento'] != null) {
            DateTime fecha = DateTime.parse(evento['fecha_hora_inicial_evento']);
            DateTime fechaInicio = DateTime(fecha.year, fecha.month, fecha.day);
            if (!eventosMap.containsKey(fechaInicio)) {
              eventosMap[fechaInicio] = [];
            }
            eventosMap[fechaInicio]?.add(evento);
          }
        }

        setState(() {
          _eventos = eventosMap;
        });
      } else {
        throw Exception('Failed to load eventos');
      }
    } catch (e) {
      print('Error fetching eventos: $e');
    }
  }

  List<dynamic> _getEventosForDay(DateTime day) {
    DateTime dateKey = DateTime(day.year, day.month, day.day);
    return _eventos[dateKey] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eventos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
          if (_getEventosForDay(selectedDay).isNotEmpty) {
            Navigator.pushNamed(
              context,
              '/eventos_del_dia',
              arguments: {
                'fecha': selectedDay,
                'eventos': _getEventosForDay(selectedDay),
              },
            );
          }
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        eventLoader: _getEventosForDay, // Carga de eventos para mostrar las bolitas
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
            color: Colors.lightBlue, // Color para los marcadores de eventos (bolitas)
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
        currentIndex: _selectedIndex,
      ),
    );
  }
}
