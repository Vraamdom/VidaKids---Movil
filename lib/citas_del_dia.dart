import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importar intl para formatear la fecha
import 'menu_footer.dart'; // Asegúrate de importar el footer
import 'dart:convert'; // Para convertir JSON
import 'package:http/http.dart' as http; // Para hacer la solicitud HTTP

class CitasDelDiaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenemos los argumentos pasados desde la página anterior
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Verifica si args es null y maneja el error en caso de que lo sea
    if (args == null) {
      return Scaffold(
        body: Center(
          child: Text('No se recibieron datos'),
        ),
      );
    }

    final DateTime fecha = args['fecha'] ?? DateTime.now();
    final List<dynamic> citas = args['citas'] ?? [];

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
        iconTheme: IconThemeData(
            color: Colors.white), // Color blanco para la flecha de devolver
      ),
      body: ListView.builder(
        itemCount: citas.length,
        itemBuilder: (context, index) {
          final cita = citas[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    cita['nombre_cita'] ??
                        'Cita con: ${cita['profesional_eps'] ?? 'Desconocido'}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Lugar: ${cita['direccion'] ?? 'No disponible'}\nInicio cita: ${_formatDateTime(cita['fecha_inicio_cita'])}',
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
        currentIndex:
            0, // Índice de citas (si quieres resaltar la sección de citas)
      ),
    );
  }

  Future<void> _mostrarDetallesCita(BuildContext context, dynamic cita) async {
    final int? idOrden = cita['id_orden'];
    final int? idBeneficiario = cita['id_beneficiario'];
    Map<String, dynamic>? orden;
    Map<String, dynamic>? beneficiario;

    // Hacemos una solicitud HTTP para obtener los detalles de la orden si id_orden no es nulo
    if (idOrden != null) {
      final response =
          await http.get(Uri.parse('http://localhost:8000/orden/$idOrden'));

      if (response.statusCode == 200) {
        orden = json.decode(response.body);
      } else {
        print('Error al obtener la orden: ${response.statusCode}');
      }
    }

   

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Bordes redondeados del modal
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
                      cita['nombre_cita'] ??
                          'Cita con el profesional : ${cita['profesional_eps'] ?? 'Desconocido'}',
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
                  _buildDetailRow('Nombre del Beneficiario',
                      '${cita['beneficiario']?['nombre_beneficiario'] ?? 'No disponible'} ${cita['beneficiario']?['apellido_beneficiario'] ?? ''}'),
                  _buildDetailRow(
                      'Documento del Beneficiario',
                      cita['documento_beneficiario']?.toString() ??
                          'No disponible'),
                  _buildDetailRow('Profesional EPS',
                      cita['profesional_eps'] ?? 'No disponible'),
                  _buildDetailRow('Teléfono',
                      cita['telefono']?.toString() ?? 'No disponible'),
                  _buildDetailRow('Número de Autorización',
                      cita['numero_autorizacion'] ?? 'No disponible'),
                  _buildDetailRow('Fecha de Autorización',
                      _formatDateTime(cita['fecha_autorizacion'])),

                  // Mostrar los detalles de la orden si está disponible
                  if (orden != null) ...[
                    SizedBox(height: 20),
                    Divider(color: Colors.grey),
                    _buildSectionTitle('Detalles de la Orden'),
                    _buildDetailRow(
                        'Entidad Profesional Remisión',
                        orden['entidad_profesional_remision'] ??
                            'No disponible'),
                    _buildDetailRow('Estado de la Orden',
                        orden['estado_orden'] ?? 'No disponible'),
                    _buildDetailRow('Diagnóstico Principal',
                        orden['diagnostico_principal'] ?? 'No disponible'),
                    _buildDetailRow('Sesión Actual',
                        orden['sesion']?.toString() ?? 'No disponible'),
                    _buildDetailRow('Total de Sesiones',
                        orden['sesiones']?.toString() ?? 'No disponible'),
                    _buildDetailRow('Observaciones',
                        orden['observaciones'] ?? 'No disponible'),
                  ],

                  SizedBox(height: 20),
                  // Botón de cerrar
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue, // Color del botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Bordes redondeados del botón
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child:
                          Text('Cerrar', style: TextStyle(color: Colors.white)),
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

  // Formatear la fecha y hora en AM/PM
  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return 'No disponible';

    try {
      final DateTime dateTime = DateTime.parse(dateTimeStr);
      final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return 'Formato de fecha inválido';
    }
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
}
