import 'package:flutter/material.dart';

class EventosDelDiaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final DateTime fecha = args['fecha'];
    final List<dynamic> eventos = args['eventos'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eventos del Día',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: eventos.length,
        itemBuilder: (context, index) {
          final evento = eventos[index];
          return ListTile(
            title: Text(
              evento['nombre_evento'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Lugar: ${evento['lugar_realizacion']}\nFinaliza: ${evento['fecha_hora_final_evento']}',
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.lightBlue, // Flecha con el color del AppBar
            ),
            onTap: () {
              _mostrarDetallesEvento(context, evento);
            },
          );
        },
      ),
    );
  }

  void _mostrarDetallesEvento(BuildContext context, dynamic evento) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(evento['nombre_evento']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lugar: ${evento['lugar_realizacion']}'),
              SizedBox(height: 10),
              Text('Fecha de Inicio: ${evento['fecha_hora_inicial_evento']}'),
              Text('Fecha de Finalización: ${evento['fecha_hora_final_evento']}'),
              SizedBox(height: 10),
              Text('Descripción: ${evento['descripcion_evento']}'),
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
