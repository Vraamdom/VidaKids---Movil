import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventosPage extends StatefulWidget {
  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _eventos = {};
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchEventos();
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
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load eventos';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching eventos: $e';
        _isLoading = false;
      });
    }
  }

  List<dynamic> _getEventosForDay(DateTime day) {
    DateTime dateKey = DateTime(day.year, day.month, day.day);
    return _eventos[dateKey] ?? [];
  }

  void _showEventosDialog(List<dynamic> eventos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eventos del día'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: eventos.length,
              itemBuilder: (BuildContext context, int index) {
                var evento = eventos[index];
                return ListTile(
                  title: Text('Evento: ${evento['nombre_evento'] ?? 'Nombre no disponible'}'),
                  subtitle: Text('Lugar realización: ${evento['lugar_realizacion'] ?? 'Lugar no disponible'}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Container(
                  width: size.width,
                  height: size.height,
                  child: TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      List<dynamic> eventos = _getEventosForDay(selectedDay);
                      if (eventos.isNotEmpty) {
                        _showEventosDialog(eventos);
                      }
                    },
                    eventLoader: _getEventosForDay,
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
                ),
    );
  }
}
