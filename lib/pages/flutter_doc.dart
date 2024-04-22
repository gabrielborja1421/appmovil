import 'package:codecenter/pages/configuracion_page.dart';
import 'package:codecenter/pages/mensajes_page.dart';
import 'package:codecenter/pages/novedades_page.dart';
import 'package:codecenter/pages/perfil_page.dart';
import 'package:codecenter/widget/drawer_custom.dart';
import 'package:flutter/material.dart';

class FlutterDoc extends StatefulWidget {
  const FlutterDoc({
    super.key,
    required this.home,
  });
  final Widget home;

  @override
  State<FlutterDoc> createState() => _FlutterDocState();
}

class _FlutterDocState extends State<FlutterDoc> {
  int indexPage = 0;
  String titleAppBar = "Documentacion";
  List<Widget> listWidget = [
    const Center(),
    const PerfilView(),
    NovedadesView(),
    const ConfiguracionView(),
    const MensajesView(),
  ];
  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      String? titleTemp;
      switch (index) {
        case 0:
          titleTemp = "Doc";
          break;
        case 1:
          titleTemp = "Perfil";
        case 2:
          titleTemp = "Novedades";
        case 3:
          titleTemp = "Configuracion";
        case 4:
          titleTemp = "Mensajes";  
        default:
          titleTemp = "ERROR";
      }
      setState(() {
        titleAppBar = titleTemp!;
        indexPage = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titleAppBar),
        automaticallyImplyLeading: true,
        elevation: 5,
      ),
      drawer: const DrawerCustom(),
      body: indexPage == 0
          ? widget.home
          : IndexedStack(
              index: indexPage,
              children: listWidget,
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: 'Novedades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensajes',
          ),
        ],
        currentIndex: indexPage,
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.deepPurple,
        onTap: onItemTapped,
      ),
    );
  }
}
