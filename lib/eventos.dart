import 'package:flutter/material.dart';

class EventosPage extends StatelessWidget {
  const EventosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      body: Center(
        child: const Text('Aquí se mostrarán los eventos'),
      ),
    );
  }
}
