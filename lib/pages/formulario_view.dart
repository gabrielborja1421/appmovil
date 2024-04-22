// FormularioView.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormularioView extends StatefulWidget {
  final int idLanguage;

  const FormularioView({super.key, required this.idLanguage});

  @override
  State<FormularioView> createState() => _FormularioViewState();
}

class _FormularioViewState extends State<FormularioView> {
  Map<String, dynamic> languageData = {};

  @override
  void initState() {
    super.initState();
    fetchLanguage();
  }

  Future<void> fetchLanguage() async {
    var url = Uri.parse(
        'http://10.0.2.2:3000/api/lenguajes/${widget.idLanguage}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        languageData = json.decode(response.body);
      });
    } else {
      debugPrint('Failed to load language: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(languageData['nombre'] ?? 'Cargando...'),
      ),
      body: languageData.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: Image.asset(languageData['srcimg'].replaceAll(
                        r'D:\Users\Gabri\Escritorio\CodeCenter\assets',
                        'assets')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(languageData['info'] ?? ''),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 180,
                        child: Image.asset(languageData['img1'].replaceAll(
                            r'D:\Users\Gabri\Escritorio\CodeCenter\assets',
                            'assets')),
                      ),
                      SizedBox(
                        width: 180,
                        child: Image.asset(languageData['img2'].replaceAll(
                            r'D:\Users\Gabri\Escritorio\CodeCenter\assets',
                            'assets')),
                      ),
                    ],
                  )
                  // Aquí agregarías más widgets para mostrar toda la información que quieras del lenguaje
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
