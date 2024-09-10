import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa intl para formatear las fechas
import 'menu_footer.dart'; // Asegúrate de importar el footer

class EventosDelDiaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenemos los argumentos pasados desde la página anterior
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
        iconTheme: IconThemeData(color: Colors.white), // Color blanco para la flecha de devolver
      ),
      body: ListView.builder(
        itemCount: eventos.length,
        itemBuilder: (context, index) {
          final evento = eventos[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: InkWell(
              onTap: () {
                _mostrarDetallesEvento(context, evento);
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
                    evento['nombre_evento'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Lugar: ${evento['lugar_realizacion']}\nFinaliza: ${_formatearFechaHora(evento['fecha_hora_final_evento'])}',
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
        currentIndex: 1, // Índice de eventos
      ),
    );
  }

  // Función para mostrar los detalles del evento en un modal más atractivo
  void _mostrarDetallesEvento(BuildContext context, dynamic evento) {
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
                      evento['nombre_evento'],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey), // Línea divisoria
                  SizedBox(height: 10),
                  // Detalles del evento
                  _buildSectionTitle('Detalles del Evento'),
                  SizedBox(height: 10),
                  _buildDetailRow('Fecha de Inicio', _formatearFechaHora(evento['fecha_hora_inicial_evento'])),
                  _buildDetailRow('Fecha de Finalización', _formatearFechaHora(evento['fecha_hora_final_evento'])),
                  _buildDetailRow('Estado', evento['estado_evento']),
                  _buildDetailRow('Lugar', evento['lugar_realizacion']),
                  _buildDetailRow('Número de Invitados', evento['numero_invitados'].toString()),
                  _buildDetailRow('Encargado Fundación', evento['encargado_fundacion']), // Convertir a String
                  SizedBox(height: 20),
                  // Información de la empresa
                  _buildSectionTitle('Información de la Empresa'),
                  SizedBox(height: 10),
                  _buildDetailRow('NIT Empresa', evento['NIT_empresa'].toString()), // Convertir a String
                  _buildDetailRow('Nombre Empresa', evento['nombre_empresa']),
                  _buildDetailRow('Encargado Empresa', evento['encargado_empresa']),
                  _buildDetailRow('Teléfono Encargado', evento['telefono_encargado_empresa'].toString()), // Convertir a Strin
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
            child: Text(content, style: TextStyle(color: Colors.black87)),
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

  // Función para formatear fecha y hora en formato 12 horas
  String _formatearFechaHora(String fechaHoraStr) {
    DateTime fechaHora = DateTime.parse(fechaHoraStr);
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fechaHora);
    String horaFormateada = DateFormat('hh:mm a').format(fechaHora); // Formato de 12 horas con AM/PM
    return '$fechaFormateada a las $horaFormateada';
  }
}
