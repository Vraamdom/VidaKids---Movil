import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'citas.dart';
import 'eventos.dart';
import 'citas_del_dia.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableCalendar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/citas': (context) => CitasPage(),
        '/eventos': (context) => EventosPage(),
        '/citas-del-dia': (context) => CitasDelDiaPage(),
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
        title: Text('TableCalendar Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Citas'),
              onPressed: () => Navigator.pushNamed(context, '/citas'),
            ),
            ElevatedButton(
              child: Text('Eventos'),
              onPressed: () => Navigator.pushNamed(context, '/eventos'),
            ),
            ElevatedButton(
              child: Text('Citas del Día'),
              onPressed: () => Navigator.pushNamed(context, '/citas-del-dia'),
            ),
          ],
        ),
      ),
    );
  }
}
