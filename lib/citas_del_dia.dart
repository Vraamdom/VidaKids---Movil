// import 'package:flutter/material.dart';
// import 'menu_footer.dart'; // Asegúrate de importar el footer

// class CitasDelDiaPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Obtenemos los argumentos pasados desde la página anterior
//     final Map<String, dynamic> args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     final DateTime fecha = args['fecha'];
//     final List<dynamic> citas = args['citas'];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Citas del Día',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.lightBlue,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.white), // Color blanco para la flecha de devolver
//       ),
//       body: ListView.builder(
//         itemCount: citas.length,
//         itemBuilder: (context, index) {
//           final cita = citas[index];
//           return ListTile(
//             title: Text(
//               cita['nombre_cita'] ?? 'Cita con: ${cita['profesional_eps']}',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(
//               'Lugar: ${cita['lugar_realizacion']}\nFinaliza: ${cita['fecha_hora_final_cita']}',
//             ),
//             trailing: Icon(
//               Icons.arrow_forward_ios,
//               color: Colors.lightBlue, // Flecha con el color del AppBar
//             ),
//             onTap: () {
//               _mostrarDetallesCita(context, cita);
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: MenuFooter(
//         currentIndex: 0, // Índice de citas (si quieres resaltar la sección de citas)
//       ),
//     );
//   }

//   void _mostrarDetallesCita(BuildContext context, dynamic cita) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(cita['nombre_cita'] ?? 'Cita con: ${cita['profesional_eps']}'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Lugar: ${cita['lugar_realizacion']}'),
//               SizedBox(height: 10),
//               Text('Fecha de Inicio: ${cita['fecha_hora_inicio_cita']}'),
//               Text('Fecha de Finalización: ${cita['fecha_hora_final_cita']}'),
//               SizedBox(height: 10),
//               Text('Descripción: ${cita['descripcion_cita'] ?? "No hay descripción disponible"}'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cerrar'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'menu_footer.dart'; // Asegúrate de importar el footer

class CitasDelDiaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenemos los argumentos pasados desde la página anterior
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final DateTime fecha = args['fecha'];
    final List<dynamic> citas = args['citas'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Citas del Día',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white), // Color blanco para la flecha de devolver
      ),
      body: ListView.builder(
        itemCount: citas.length,
        itemBuilder: (context, index) {
          final cita = citas[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: InkWell(
              onTap: () {
                _mostrarDetallesCita(context, cita);
              },
              borderRadius: BorderRadius.circular(10), // Bordes redondeados
              splashColor: Colors.lightBlue.withOpacity(0.3), // Efecto "ripple"
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Fondo blanco para el contenedor
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // Sombra del contenedor
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    cita['nombre_cita'] ?? 'Cita con: ${cita['profesional_eps'] ?? 'Desconocido'}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Lugar: ${cita['direccion'] ?? 'No disponible'}\nFinaliza: ${cita['fecha_fin_cita'] ?? 'No disponible'}',
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.lightBlue, // Flecha con el color del AppBar
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: MenuFooter(
        currentIndex: 0, // Índice de citas (si quieres resaltar la sección de citas)
      ),
    );
  }

  void _mostrarDetallesCita(BuildContext context, dynamic cita) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Bordes redondeados del modal
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white, // Fondo del modal
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      cita['nombre_cita'] ?? 'Cita con: ${cita['profesional_eps'] ?? 'Desconocido'}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey), // Línea divisoria
                  SizedBox(height: 10),
                  // Detalles de la cita
                  _buildSectionTitle('Detalles de la Cita'),
                  SizedBox(height: 10),
                  _buildDetailRow('Fecha de Inicio', cita['fecha_inicio_cita'] ?? 'No disponible'),
                  _buildDetailRow('Fecha de Finalización', cita['fecha_fin_cita'] ?? 'No disponible'),
                  _buildDetailRow('Lugar', cita['direccion'] ?? 'No disponible'),
                  _buildDetailRow('Descripción', cita['descripcion_cita'] ?? "No hay descripción disponible"),
                  SizedBox(height: 20),
                  // Botón de cerrar
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue, // Color del botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Bordes redondeados del botón
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cerrar', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget para mostrar una fila de detalles con título y contenido
  Widget _buildDetailRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(content ?? 'No disponible', style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar el título de una sección
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.lightBlue,
      ),
    );
  }
}
