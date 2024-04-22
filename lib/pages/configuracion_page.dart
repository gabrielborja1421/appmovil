import 'package:flutter/material.dart';

class ConfiguracionView extends StatelessWidget {
  const ConfiguracionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Cuenta'),
              onTap: () {
                // Navegar a la configuración de la cuenta
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notificaciones'),
              onTap: () {
                // Navegar a la configuración de notificaciones
              },
            ),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Tema'),
              subtitle: const Text('Claro / Oscuro'),
              onTap: () {
                // Navegar a la configuración de tema
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Privacidad'),
              onTap: () {
                // Navegar a la configuración de privacidad
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Idioma'),
              onTap: () {
                // Navegar a la configuración de idioma
              },

            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de'),
              onTap: () {
                // Mostrar información acerca de la app
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}
