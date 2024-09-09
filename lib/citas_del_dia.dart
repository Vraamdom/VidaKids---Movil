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
          return ListTile(
            title: Text(
              cita['nombre_cita'] ?? 'Cita con: ${cita['profesional_eps']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Lugar: ${cita['lugar_realizacion']}\nFinaliza: ${cita['fecha_hora_final_cita']}',
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.lightBlue, // Flecha con el color del AppBar
            ),
            onTap: () {
              _mostrarDetallesCita(context, cita);
            },
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
        return AlertDialog(
          title: Text(cita['nombre_cita'] ?? 'Cita con: ${cita['profesional_eps']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lugar: ${cita['lugar_realizacion']}'),
              SizedBox(height: 10),
              Text('Fecha de Inicio: ${cita['fecha_hora_inicio_cita']}'),
              Text('Fecha de Finalización: ${cita['fecha_hora_final_cita']}'),
              SizedBox(height: 10),
              Text('Descripción: ${cita['descripcion_cita'] ?? "No hay descripción disponible"}'),
            ],
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
}
