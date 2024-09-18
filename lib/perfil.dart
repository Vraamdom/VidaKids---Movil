import 'package:flutter/material.dart';
import 'menu_footer.dart'; // Importa el footer
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String? nombreUsuario;
  String? correoElectronico;
  String? telefono;

  bool _isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile(); // Cargamos el perfil cuando se inicia la página
  }

  // Función para cargar el perfil desde la API
  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      int? idUsuario = prefs.getInt('id_usuario');

      if (token == null || idUsuario == null) {
        setState(() {
          errorMessage = 'No se pudo obtener la información de usuario. Inicia sesión nuevamente.';
          _isLoading = false;
        });
        return;
      }

      // Hacemos la solicitud GET al servidor con el token y el ID del usuario
      final response = await http.get(
        Uri.parse('https://vidakids-api-hx41.onrender.com/usuarios/perfil/$idUsuario'), // Cambia por tu URL
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          nombreUsuario = data['nombre_usuario'];
          correoElectronico = data['correo_electronico'];
          telefono = data['telefono'];
          _isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No se pudo cargar el perfil. Código de estado: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar el perfil. Inténtalo de nuevo.';
        _isLoading = false;
      });
    }
  }

  // Función para cerrar sesión
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpiamos todos los datos almacenados (token, id_usuario, etc.)

    // Redirigir a la pantalla de login después de cerrar sesión
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                )
              : Padding(
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
                                    'Nombre: $nombreUsuario',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Control de desbordamiento de texto
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Correo: $correoElectronico',
                                    style: TextStyle(fontSize: 16.0),
                                    overflow: TextOverflow.ellipsis, // Control de desbordamiento de texto
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Teléfono: $telefono',
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
                      // Botón para cerrar sesión, centrado
                      Center(
                        child: ElevatedButton(
                          onPressed: _logout,
                          child: Text(
                            'Cerrar sesión',
                            style: TextStyle(
                              color: Colors.white,
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
