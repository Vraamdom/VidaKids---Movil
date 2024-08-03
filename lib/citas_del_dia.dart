// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class CitasDelDiaPage extends StatefulWidget {
//   @override
//   _CitasDelDiaPageState createState() => _CitasDelDiaPageState();
// }

// class _CitasDelDiaPageState extends State<CitasDelDiaPage> {
//   List<dynamic> citas = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchCitasDelDia();
//   }

//   Future<void> fetchCitasDelDia() async {
//     final response = await http.get(Uri.parse('http://localhost:8000/citas'));
    
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         citas = data;
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       throw Exception('Failed to load citas');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Citas del Día'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: citas.length,
//               itemBuilder: (context, index) {
//                 final cita = citas[index];
//                 return ListTile(
//                   title: Text('Cita con ${cita['profesional_eps']}'),
//                   subtitle: Text('Dirección: ${cita['direccion']}'),
//                   trailing: Text('Estado: ${cita['estado_cita']}'),
//                 );
//               },
//             ),
//     );
//   }
// }












import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CitasDelDiaPage extends StatefulWidget {
  @override
  _CitasDelDiaPageState createState() => _CitasDelDiaPageState();
}

class _CitasDelDiaPageState extends State<CitasDelDiaPage> {
  Map<String, List<dynamic>> citasPorFecha = {};
  List<dynamic> todasLasCitas = [];
  bool isLoading = true;
  String errorMessage = '';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchCitas();
  }

  Future<void> fetchCitas() async {
    final url = 'http://localhost:8000/citas'; // Asegúrate de que la URL es correcta
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Datos recibidos: $data'); // Depuración

        setState(() {
          todasLasCitas = data;
          citasPorFecha = agruparCitasPorFecha(data);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load citas: $e';
      });
    }
  }

  Map<String, List<dynamic>> agruparCitasPorFecha(List<dynamic> citas) {
    Map<String, List<dynamic>> citasPorFecha = {};
    for (var cita in citas) {
      String fechaInicio = cita['fecha_inicio_cita']?.toString().split('T')[0] ?? 'Fecha no disponible'; // Usa 'fecha_inicio_cita'
      if (!citasPorFecha.containsKey(fechaInicio)) {
        citasPorFecha[fechaInicio] = [];
      }
      citasPorFecha[fechaInicio]!.add(cita);
    }
    print('Citas agrupadas por fecha: $citasPorFecha'); // Depuración
    return citasPorFecha;
  }

  List<dynamic> obtenerCitasParaFecha(DateTime fecha) {
    final fechaString = DateFormat('yyyy-MM-dd').format(fecha);
    return citasPorFecha[fechaString] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Citas del Día'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (selected != null && selected != selectedDate) {
                setState(() {
                  selectedDate = selected;
                });
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Citas para ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: obtenerCitasParaFecha(selectedDate).length,
                        itemBuilder: (context, index) {
                          final cita = obtenerCitasParaFecha(selectedDate)[index];
                          return ListTile(
                            title: Text('Cita con ${cita['profesional_eps'] ?? 'Desconocido'}'), // Maneja valores null
                            subtitle: Text('Dirección: ${cita['direccion'] ?? 'No disponible'}'), // Maneja valores null
                            trailing: Text('Estado: ${cita['estado_cita'] ?? 'No disponible'}'), // Maneja valores null
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedDate = DateTime.now();
                        });
                      },
                      child: Text('Ver todas las citas'),
                    ),
                  ],
                ),
    );
  }
}
