// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:codecenter/articulos/api_service.dart';
import 'package:codecenter/articulos/response_api.dart';
import 'package:codecenter/widget/message_scaffold.dart';
import 'package:flutter/material.dart';

class Novedad {
  final int id;
  final String titulo;
  final String descripcion;
  final String imageUrl;

  Novedad({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'imageUrl': imageUrl,
    };
  }

  factory Novedad.fromMap(Map<String, dynamic> map) {
    return Novedad(
      id: map['id'],
      titulo: map['nombre'],
      descripcion: map['descripcion'],
      imageUrl: map['imgsrc'],
    );
  }
}

class NovedadesView extends StatefulWidget {
  const NovedadesView({super.key});

  @override
  State<NovedadesView> createState() => _NovedadesViewState();
}

class _NovedadesViewState extends State<NovedadesView> {
  final apiService = ApiService();
  late Future<List<Novedad>> novedades;

  @override
  void initState() {
    super.initState();
    novedades = fetchNovedad();
  }

  Future<List<Novedad>> fetchNovedad() async {
    ResponseAPI responseAPI = await apiService.requestGet(
      uri: 'http://10.0.2.2:3000/api/novedades',
    );

    if (responseAPI.status == 200) {
      List<Map<String, dynamic>> jsonResponse = List<Map<String, dynamic>>.from(
        responseAPI.body,
      );
      return jsonResponse
          .map(
            (map) => Novedad.fromMap(map),
          )
          .toList();
    } else {
      throw Exception('Failed to load languages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Novedades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              try {
                final apiService = ApiService();
                late ResponseAPI responseAPI;
                Map<String, String>? map = await inputsPOST(
                  context,
                );
                if (map == null || map.isEmpty) return;
                responseAPI = await apiService.requestPost(
                  uri: 'http://10.0.2.2:3000/api/novedades',
                  data: {
                    "nombre": map['nombre'],
                    "imgsrc": map['imgsrc'],
                    "descripcion": map['descripcion']
                  },
                );
                if (!mounted) return;
                messageScaffold(
                  context: context,
                  text: responseAPI.message,
                );
              } catch (e) {
                if (!mounted) return;
                messageScaffold(
                  context: context,
                  text: 'Error al crear datos',
                );
              }
            },
          ),
        ],
      ),
      body: Expanded(
        child: FutureBuilder<List<Novedad>>(
          future: novedades,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.map(
                  (novedad) {
                    return Card(
                      child: ListTile(
                        leading: Image.asset(
                          // TODO: Agregar Imagenes al ASSETS
                          novedad.imageUrl,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        title: Text(novedad.titulo),
                        subtitle: Text(novedad.descripcion),
                        trailing: PopupMenuButton<String>(
                          onSelected: (String result) async {
                            final apiService = ApiService();
                            late ResponseAPI responseAPI;
                            if (result == 'put') {
                              try {
                                Map<String, String>? map = await inputsPut(
                                  context,
                                  novedad,
                                );
                                if (map == null || map.isEmpty) return;

                                responseAPI = await apiService.requestPut(
                                  uri: 'http://10.0.2.2:3000/api/novedades',
                                  id: novedad.id,
                                  data: {
                                    "nombre": map['nombre'],
                                    "imgsrc": map['imgsrc'],
                                    "descripcion": map['descripcion']
                                  },
                                );
                                messageScaffold(
                                  context: context,
                                  text: responseAPI.message,
                                );
                              } catch (e) {
                                if (!mounted) return;
                                messageScaffold(
                                  context: context,
                                  text: 'Error al actualizar datos',
                                );
                              }
                            } else if (result == "delete") {
                              try {
                                responseAPI = await apiService.requestDelete(
                                  uri: 'http://10.0.2.2:3000/api/novedades',
                                  id: novedad.id,
                                );
                                messageScaffold(
                                  context: context,
                                  text: responseAPI.message,
                                );
                              } catch (e) {
                                if (!mounted) return;
                                messageScaffold(
                                  context: context,
                                  text: 'Error al actualizar datos',
                                );
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'put',
                              child: Text(
                                'Actualizar',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text(
                                'Eliminar',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ).toList(),
              );
            } else {
              return const Center(
                child: Text('No languages found.'),
              );
            }
          },
        ),
      ),
    );
  }

  Future<Map<String, String>?> inputsPut(
      BuildContext context, Novedad novedad) async {
    final Completer<Map<String, String>?> completer = Completer();
    final tituloController = TextEditingController();
    final imageUrlController = TextEditingController();
    final descripcionController = TextEditingController();

    showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        String nombre = '';
        String imgsrc = '';
        String descripcion = '';

        tituloController.text = novedad.titulo;
        imageUrlController.text = novedad.imageUrl;
        descripcionController.text = novedad.descripcion;

        return AlertDialog(
          title: const Text('Ingresa los detalles'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombre:'),
                  controller: tituloController,
                  onSaved: (value) => nombre = value ?? '',
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Este campo es requerido'
                        : null;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'URL de la imagen:'),
                  controller: imageUrlController,
                  onSaved: (value) => imgsrc = value ?? '',
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Este campo es requerido'
                        : null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descripción:'),
                  controller: descripcionController,
                  onSaved: (value) => descripcion = value ?? '',
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Este campo es requerido'
                        : null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  completer.complete({
                    'nombre': nombre,
                    'imgsrc': imgsrc,
                    'descripcion': descripcion,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    ).then((_) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });

    return completer.future;
  }

  Future<Map<String, String>?> inputsPOST(
    BuildContext context,
  ) async {
    final Completer<Map<String, String>?> completer = Completer();

    showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        String nombre = '';
        String imgsrc = '';
        String descripcion = '';

        return AlertDialog(
          title: const Text('Ingresa los detalles'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombre:'),
                  onSaved: (value) => nombre = value ?? '',
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Este campo es requerido'
                        : null;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'URL de la imagen:'),
                  onSaved: (value) => imgsrc = value ?? '',
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Este campo es requerido'
                        : null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descripción:'),
                  onSaved: (value) => descripcion = value ?? '',
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Este campo es requerido'
                        : null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  completer.complete({
                    'nombre': nombre,
                    'imgsrc': imgsrc,
                    'descripcion': descripcion,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    ).then((_) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });

    return completer.future;
  }
}
