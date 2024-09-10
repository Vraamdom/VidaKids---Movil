import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vidakids_movil/perfil.dart';
import 'citas.dart';
import 'eventos.dart';
import 'citas_del_dia.dart';
import 'eventos_del_dia.dart';
import 'login.dart'; // Importa la pantalla de login

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VidaKids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Cambia la ruta inicial para que apunte a la pantalla de login
      initialRoute: '/login', 
      routes: {
        '/': (context) => StartPage(),
        '/login': (context) => LoginPage(), // Pantalla de login
        '/citas': (context) => CitasPage(),
        '/eventos': (context) => EventosPage(),
        '/citas_del_dia': (context) => CitasDelDiaPage(),
        '/perfil': (context) => PerfilPage(),
        '/eventos_del_dia': (context) => EventosDelDiaPage(),
        '/main': (context) => StartPage(),
      },
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'VidaKids',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        color: Colors.lightBlue[50], // Fondo del menú más claro, casi blanco
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            _buildMenuItem(
              context, 
              'Citas', 
              Icons.calendar_today, 
              '/citas'
            ),
            _buildMenuItem(
              context, 
              'Eventos', 
              Icons.event, 
              '/eventos'
            ),
            _buildMenuItem(
              context, 
              'Citas del Día', 
              Icons.today, 
              '/citas_del_dia'
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.blue),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
