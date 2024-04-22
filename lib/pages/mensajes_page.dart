// ignore_for_file: use_build_context_synchronously

import 'package:codecenter/articulos/api_service.dart';
import 'package:codecenter/articulos/response_api.dart';
import 'package:codecenter/widget/message_scaffold.dart';
import 'package:flutter/material.dart';

class MensajesView extends StatefulWidget {
  const MensajesView({super.key});

  @override
  State<MensajesView> createState() => _MensajesViewState();
}

class _MensajesViewState extends State<MensajesView> {
  final apiService = ApiService();

  Future<List<Map<String, dynamic>>> fetchMensajes() async {
    ResponseAPI responseAPI = await apiService.requestGet(
      uri: 'https://3bcc-187-132-201-149.ngrok-free.app/api/mensajes',
    );

    if (responseAPI.status == 200) {
      return List<Map<String, dynamic>>.from(responseAPI.body);
    } else {
      throw Exception('Failed to load languages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessageCreate(),
                ),
              );
            },
            icon: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMensajes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No hay mensajes disponibles.'));
          } else {
            var mensajes = snapshot.data!;
            return ListView.builder(
              itemCount: mensajes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(mensajes[index]["titulo"]),
                  subtitle: Text(mensajes[index]["contenido"]),
                  trailing: Text(mensajes[index]["fecha"]),
                  onTap: () {
                    showAlertDialogOptions(
                      context,
                      mensajes[index]['titulo'],
                      mensajes[index],
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

void showAlertDialogOptions(
  BuildContext context,
  String label,
  Map<String, dynamic> mensaje,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageUpdate(
                        message: mensaje,
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
                      uri: 'https://3bcc-187-132-201-149.ngrok-free.app/api/mensajes',
                      id: mensaje['idmensajes'],
                    );

                    Navigator.pop(context);
                    if (responseAPI.status == 200) {
                      messageScaffold(
                        context: context,
                        text:
                            'Se elimino el lenguaje ${mensaje['titulo']} con exito',
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

class MessageUpdate extends StatefulWidget {
  final Map<String, dynamic> message;
  const MessageUpdate({super.key, required this.message});

  @override
  State<MessageUpdate> createState() => _MessageUpdateState();
}

class _MessageUpdateState extends State<MessageUpdate> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  final apiService = ApiService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tituloController.text = widget.message['titulo'];
    _contenidoController.text = widget.message['contenido'];
    _fechaController.text = widget.message['fecha'];
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  void _actualizarMensaje() async {
    try {
      ResponseAPI responseAPI = await apiService.requestPut(
        uri: 'https://3bcc-187-132-201-149.ngrok-free.app/api/mensajes',
        id: widget.message['idmensajes'],
        data: {
          "titulo": _tituloController.text,
          "contenido": _contenidoController.text,
          "fecha": _fechaController.text,
        },
      );

      if (!mounted) return;
      Navigator.pop(context);
      if (responseAPI.status == 200) {
        messageScaffold(
          context: context,
          text: 'Se realizo el cambio con exito',
        );

        Navigator.pop(context);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Mensaje'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
              ),
            ),
            TextFormField(
              controller: _contenidoController,
              decoration: const InputDecoration(
                labelText: 'Contenido',
              ),
              minLines: 1,
              maxLines: 10,
            ),
            TextFormField(
              controller: _fechaController,
              decoration: const InputDecoration(
                labelText: 'Fecha',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _actualizarMensaje,
              icon: const Icon(Icons.update),
              label: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageCreate extends StatefulWidget {
  const MessageCreate({super.key});

  @override
  State<MessageCreate> createState() => _MessageCreateState();
}

class _MessageCreateState extends State<MessageCreate> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  final apiService = ApiService();

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  void _actualizarMensaje() async {
    try {
      ResponseAPI responseAPI = await apiService.requestPost(
        uri: 'https://3bcc-187-132-201-149.ngrok-free.app/api/mensajes',
        data: {
          "titulo": _tituloController.text,
          "contenido": _contenidoController.text,
          "fecha": _fechaController.text,
        },
      );

      if (!mounted) return;
      Navigator.pop(context);
      if (responseAPI.status == 200) {
        messageScaffold(
          context: context,
          text: 'Se creo el mensaje con exito',
        );

        Navigator.pop(context);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Mensaje'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
              ),
            ),
            TextFormField(
              controller: _contenidoController,
              decoration: const InputDecoration(
                labelText: 'Contenido',
              ),
              minLines: 1,
              maxLines: 10,
            ),
            TextFormField(
              controller: _fechaController,
              decoration: const InputDecoration(
                labelText: 'Fecha',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _actualizarMensaje,
              icon: const Icon(Icons.add),
              label: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }
}
