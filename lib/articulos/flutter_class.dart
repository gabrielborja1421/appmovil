import 'package:flutter/material.dart';

class FlutterClass extends StatefulWidget {
  const FlutterClass({
    super.key,
  });

  @override
  State<FlutterClass> createState() => _FlutterClassState();
}

class _FlutterClassState extends State<FlutterClass> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          child: Image.network(
            "https://www.mashfrog.com/sites/default/files/2023-02/1920x1080_cover_B%20%281%29.png",
          ),
        ),
        const Text("Flutter"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.grey,
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: Colors.black,
                ),
                left: BorderSide(
                  width: 0.5,
                  color: Colors.black,
                ),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: const Text(
                "Flutter es un SDK desarrollado por Google para crear aplicaciones móviles tanto para Android como para iOS (Apple). Fue desarrollado como un software para uso interno dentro de la compañía pero vieron el potencial que tenia y decidieron lanzarlo como proyecto de código libre. Actualmente es uno de los proyectos de desarrollo de aplicaciones móviles que más está creciendo. Además, desde la última versión estable, también es posible realizar aplicaciones Web y de escritorio para Windows y Mac. Aunque en estas dos plataformas aún está en fase experimental (beta).",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Whisper',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              r"assets\images\logo_android.png",
              width: 150,
              height: 150,
            ),
            Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Apple_Studios.svg/800px-Apple_Studios.svg.png",
              width: 130,
              height: 130,
            )
          ],
        ),
      ],
    );
  }
}
