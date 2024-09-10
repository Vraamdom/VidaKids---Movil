import 'package:flutter/material.dart';
import 'menu_footer.dart'; // Importa el footer

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: TextStyle(
            color: Colors.white, // Texto del título en blanco
            fontWeight: FontWeight.bold, // Texto en negrita
          ),
        ),
        backgroundColor: Colors.lightBlue, // Mismo color de fondo que en eventos
        centerTitle: true, // Centrar el título
        iconTheme: IconThemeData(color: Colors.white), // Color de la flecha de retroceso
        automaticallyImplyLeading: false, // Oculta la flecha de retroceso
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenedor para el icono y la información básica
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // Cambia la posición de la sombra
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icono de persona a la izquierda
                  Icon(
                    Icons.person,
                    size: 80.0,
                    color: Colors.lightBlue,
                  ),
                  SizedBox(width: 16.0),
                  // Información básica a la derecha dentro de Expanded
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre: Juan Pérez',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis, // Control de desbordamiento de texto
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Correo: juan.perez@example.com',
                          style: TextStyle(fontSize: 16.0),
                          overflow: TextOverflow.ellipsis, // Control de desbordamiento de texto
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Teléfono: +123456789',
                          style: TextStyle(fontSize: 16.0),
                          overflow: TextOverflow.ellipsis, // Control de desbordamiento de texto
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Contenedor con más información
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Más información:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Esta es información adicional que luego será reemplazada por datos de la base de datos.',
                    style: TextStyle(fontSize: 16.0),
                    overflow: TextOverflow.clip, // Para asegurarse de que el texto no se desborde
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0),
            // Botón para salir, centrado
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main', // Redirige al main.dart
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text(
                  'Salir',
                  style: TextStyle(
                    color: Colors.white, // Cambiamos el color de la letra a blanco
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.lightBlue, // Color de fondo del botón
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bordes menos redondeados
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Agregamos el MenuFooter
      bottomNavigationBar: MenuFooter(
        currentIndex: 2, // Índice para la página de perfil
      ),
    );
  }
}
