// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:codecenter/articulos/api_service.dart';
import 'package:codecenter/articulos/response_api.dart';
import 'package:codecenter/widget/message_scaffold.dart';
import 'package:flutter/material.dart';

import '../pages/formulario_view.dart';

class DrawerCustom extends StatefulWidget {
  const DrawerCustom({super.key});

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  final link = " https://3bcc-187-132-201-149.ngrok-free.app";
  final apiService = ApiService();
  late Future<List<Map<String, dynamic>>> futureLanguages;

  @override
  void initState() {
    super.initState();
    futureLanguages = fetchLanguages();
  }

  Future<List<Map<String, dynamic>>> fetchLanguages() async {
    ResponseAPI responseAPI = await apiService.requestGet(
      uri: ('https://3bcc-187-132-201-149.ngrok-free.app/api/lenguajes'),
    );

    if (responseAPI.status == 200) {
      return List<Map<String, dynamic>>.from(responseAPI.body);
    } else {
      throw Exception('Failed to load languages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(40.0),
            child: const Text(
              "Lenguajes Actuales",
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Whisper',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: futureLanguages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!
                        .map((language) => ListTile(
                              title: Text(language['nombre']),
                              trailing: const Icon(Icons.arrow_right),
                              onLongPress: () {
                                Navigator.pop(context);
                                showAlertDialogOptions(
                                  context,
                                  language['nombre'],
                                  language,
                                );
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FormularioView(
                                        idLanguage: language['idlenguaje']),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  );
                } else {
                  return const Center(child: Text('No languages found.'));
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add More'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LenguajesCreate(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

void showAlertDialogOptions(
  BuildContext context,
  String label,
  Map<String, dynamic> lenguajes,
) {
  final apiService = ApiService();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Seleccione una opción\n"$label"',
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.only(top: 25, bottom: 15),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LenguajesUpdate(
                        lenguajes: lenguajes,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: IconButton(
                onPressed: () async {
                  try {
                    ResponseAPI responseAPI = await apiService.requestDelete(
                      uri: 'https://3bcc-187-132-201-149.ngrok-free.app/api/lenguajes',
                      id: lenguajes['idlenguaje'],
                    );

                    Navigator.pop(context);
                    if (responseAPI.status == 200) {
                      messageScaffold(
                        context: context,
                        text:
                            'Se elimino el lenguaje ${lenguajes['nombre']} con exito',
                      );
                    } else {
                      messageScaffold(
                        context: context,
                        text: responseAPI.message,
                      );
                    }
                  } catch (e) {
                    Navigator.pop(context);
                    messageScaffold(
                      context: context,
                      text: 'ERROR: $e',
                    );
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class LenguajesUpdate extends StatefulWidget {
  final Map<String, dynamic> lenguajes;
  const LenguajesUpdate({
    super.key,
    required this.lenguajes,
  });

  @override
  State<LenguajesUpdate> createState() => _LenguajesUpdateState();
}

class _LenguajesUpdateState extends State<LenguajesUpdate> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _srcimgController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _img1Controller = TextEditingController();
  final TextEditingController _img2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.lenguajes['nombre'];
    _srcimgController.text = widget.lenguajes['srcimg'];
    _infoController.text = widget.lenguajes['info'];
    _img1Controller.text = widget.lenguajes['img1'];
    _img2Controller.text = widget.lenguajes['img2'];
  }

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Actualizar Lenguajes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo no puede estar vacío';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _srcimgController,
              decoration: const InputDecoration(labelText: 'Srcimg'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo no puede estar vacío';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _infoController,
              decoration: const InputDecoration(labelText: 'Info'),
              minLines: 2,
              maxLines: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo no puede estar vacío';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _img1Controller,
              decoration: const InputDecoration(labelText: 'Img1'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo no puede estar vacío';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _img2Controller,
              decoration: const InputDecoration(labelText: 'Img2'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo no puede estar vacío';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.create),
              label: const Text('Actualizar'),
              onPressed: () async {
                try {
                  ResponseAPI responseAPI = await apiService.requestPut(
                    uri: 'https://3bcc-187-132-201-149.ngrok-free.app/api/lenguajes',
                    id: widget.lenguajes['idlenguaje'],
                    data: {
                      "nombre": _nombreController.text,
                      "srcimg": _srcimgController.text,
                      "info": _infoController.text,
                      "img1": _img1Controller.text,
                      "img2": _img2Controller.text
                    },
                  );

                  if (!mounted) return;
                  Navigator.pop(context);
                  if (responseAPI.status == 200) {
                    messageScaffold(
                      context: context,
                      text: 'Se realizo el cambio con exito',
                    );
                  } else {
                    messageScaffold(
                      context: context,
                      text: responseAPI.message,
                    );
                  }
                } catch (e) {
                  messageScaffold(
                    context: context,
                    text: 'Hubo un error',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LenguajesCreate extends StatefulWidget {
  const LenguajesCreate({
    super.key,
  });

  @override
  State<LenguajesCreate> createState() => _LenguajesCreateState();
}

class _LenguajesCreateState extends State<LenguajesCreate> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _srcimgController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _img1Controller = TextEditingController();
  final TextEditingController _img2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Crear Lenguaje'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo no puede estar vacío';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _srcimgController,
              decoration: const InputDecoration(labelText: 'Srcimg'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo no puede estar vacío';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _infoController,
              decoration: const InputDecoration(labelText: 'Info'),
              minLines: 2,
              maxLines: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo no puede estar vacío';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _img1Controller,
              decoration: const InputDecoration(labelText: 'Img1'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo no puede estar vacío';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _img2Controller,
              decoration: const InputDecoration(labelText: 'Img2'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo no puede estar vacío';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.create),
              label: const Text('Crear'),
              onPressed: () async {
                try {
                  ResponseAPI responseAPI = await apiService.requestPost(
                    uri: 'https://3bcc-187-132-201-149.ngrok-free.app/api/lenguaje',
                    data: {
                      "nombre": _nombreController.text,
                      "srcimg": _srcimgController.text,
                      "info": _infoController.text,
                      "img1": _img1Controller.text,
                      "img2": _img2Controller.text
                    },
                  );

                  if (!mounted) return;
                  Navigator.pop(context);
                  if (responseAPI.status == 200) {
                    messageScaffold(
                      context: context,
                      text: 'Se creo el lenguaje con exito',
                    );
                  } else {
                    messageScaffold(
                      context: context,
                      text: responseAPI.message,
                    );
                  }
                } catch (e) {
                  messageScaffold(
                    context: context,
                    text: 'Hubo un error',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
