import 'package:flutter/material.dart';

class MenuFooter extends StatelessWidget {
  final int currentIndex;

  MenuFooter({required this.currentIndex});

  void _onItemTapped(int index, BuildContext context) {
    // Navegación a las diferentes páginas según el índice
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/citas');
        break;
      case 1:
        Navigator.pushNamed(context, '/eventos');
        break;
      case 2:
        Navigator.pushNamed(context, '/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        _onItemTapped(index, context); // Navegación al presionar un ítem
      },
      backgroundColor: Colors.lightBlue, // Fondo azul para que coincida con el navbar
      selectedItemColor: Colors.white, // Color blanco para el ítem seleccionado
      unselectedItemColor: Colors.white70, // Color más claro para los ítems no seleccionados
      selectedFontSize: 16.0, // Tamaño de texto mayor para el ítem seleccionado
      unselectedFontSize: 14.0, // Tamaño de texto menor para los no seleccionados
      showUnselectedLabels: true, // Mostrar etiquetas en los ítems no seleccionados
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_today,
            color: currentIndex == 0 ? Colors.white : Colors.white70, // Icono blanco si está seleccionado
          ),
          label: 'Citas',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.event,
            color: currentIndex == 1 ? Colors.white : Colors.white70, // Icono blanco si está seleccionado
          ),
          label: 'Eventos',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: currentIndex == 2 ? Colors.white : Colors.white70, // Icono blanco si está seleccionado
          ),
          label: 'Perfil',
        ),
      ],
    );
  }
}
