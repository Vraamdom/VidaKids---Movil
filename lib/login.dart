import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? errorMessage;

  // Función para manejar el login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        errorMessage = null;
      });

      final correoElectronico = emailController.text;
      final contrasena = passwordController.text;

      try {
        // Realizar la solicitud POST
        final response = await http.post(
          Uri.parse('http://localhost:8000/auth/login'), // Cambia por tu URL de backend
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'correo_electronico': correoElectronico,
            'contrasena': contrasena,
          }),
        );

        print("Código de estado de la respuesta: ${response.statusCode}");
        print("Cuerpo de la respuesta: ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // Verificamos que el token y el ID del usuario estén presentes
          final token = data['token'];
          final idUsuario = data['user']['id'];

          print("Token recibido: $token");
          print("ID de usuario recibido: $idUsuario");

          // Si todo está bien, almacenamos el token e ID en SharedPreferences
          if (token != null && idUsuario != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token);
            await prefs.setInt('id_usuario', idUsuario);

            // Navegar al perfil después del login exitoso
            Navigator.pushReplacementNamed(context, '/perfil');
          } else {
            setState(() {
              errorMessage = 'No se pudo obtener el token o ID de usuario. Inténtalo de nuevo.';
            });
          }
        } else {
          setState(() {
            errorMessage = 'Credenciales inválidas. Verifica tu correo y contraseña.';
          });
        }
      } catch (e) {
        print("Error durante la solicitud: $e");
        setState(() {
          errorMessage = 'Error de red. Inténtalo de nuevo más tarde.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo con opacidad
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/img/login.jpeg'), // Cambia por la imagen de fondo
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
              ),
            ),
          ),
          // Contenido del formulario
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo del aplicativo más grande
                    Image.asset(
                      'lib/img/logo.png', // Cambia por tu logo
                      height: 160.0, // Aumentamos el tamaño del logo
                    ),
                    SizedBox(height: 30),
                    // Formulario de login
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Campo de email
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black), // Letra negra en el campo de texto
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                              labelStyle: TextStyle(color: Colors.black), // Cambiamos la letra de la etiqueta a negro
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black), // Cambiamos el borde a negro
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black), // Cambiamos el borde a negro cuando se enfoca
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu correo';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Ingresa un correo válido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          // Campo de contraseña
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(color: Colors.black), // Letra negra en el campo de texto
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(color: Colors.black), // Cambiamos la letra de la etiqueta a negro
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black), // Cambiamos el borde a negro
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black), // Cambiamos el borde a negro cuando se enfoca
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu contraseña';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          // Botón de login
                          _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 80, vertical: 15),
                                    backgroundColor: Colors.lightBlue,
                                    textStyle: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Letra blanca en el botón
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Iniciar sesión',
                                    style: TextStyle(
                                      color: Colors.white, // Letra blanca
                                    ),
                                  ),
                                ),
                          SizedBox(height: 10),
                          // Mostrar mensajes de error si hay
                          if (errorMessage != null)
                            Text(
                              errorMessage!,
                              style: TextStyle(color: Colors.black),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
