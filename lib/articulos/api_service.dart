import 'dart:convert';
import 'package:codecenter/articulos/response_api.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<ResponseAPI> requestGet({
    required String uri,
  }) async {
    try {
      var url = Uri.parse(uri);
      var res = await http.get(url);

      if (res.statusCode == 200) {
        return ResponseAPI(
          status: res.statusCode,
          message: 'Successful',
          body: jsonDecode(res.body),
        );
      } else {
        return ResponseAPI(
          status: res.statusCode,
          message: res.reasonPhrase ?? 'Error al consumir EndPoint',
        );
      }
    } catch (e) {
      return ResponseAPI(
        status: 500,
        message: 'Error: $e',
      );
    }
  }

  Future<ResponseAPI> requestPost({
    required String uri,
    required Map<String, dynamic> data,
  }) async {
    try {
      var url = Uri.parse(uri);
      var res = await http.post(
        url,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 201) {
        return ResponseAPI(
          status: res.statusCode,
          message: 'Successful',
          body: jsonDecode(res.body),
        );
      } else {
        return ResponseAPI(
          status: res.statusCode,
          message: res.reasonPhrase ?? 'Error al consumir EndPoint',
        );
      }
    } catch (e) {
      return ResponseAPI(
        status: 500,
        message: 'Error: $e',
      );
    }
  }

  Future<ResponseAPI> requestPut({
    required String uri,
    required int id,
    required Map<String, dynamic>? data,
  }) async {
    try {
      var url = Uri.parse('$uri/$id');
      var res = await http.put(
        url,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        return ResponseAPI(
          status: res.statusCode,
          message: 'Successful',
          body: jsonDecode(res.body),
        );
      } else {
        return ResponseAPI(
          status: res.statusCode,
          message: res.reasonPhrase ?? 'Error al consumir EndPoint',
        );
      }
    } catch (e) {
      return ResponseAPI(
        status: 500,
        message: 'Error: $e',
      );
    }
  }

  Future<ResponseAPI> requestDelete({
    required String uri,
    required int id,
  }) async {
    try {
      var url = Uri.parse('$uri/$id');
      var res = await http.delete(url);

      if (res.statusCode == 200) {
        return ResponseAPI(
          status: res.statusCode,
          message: 'Successful',
          body: jsonDecode(res.body),
        );
      } else {
        return ResponseAPI(
          status: res.statusCode,
          message: res.reasonPhrase ?? 'Error al consumir EndPoint',
        );
      }
    } catch (e) {
      return ResponseAPI(
        status: 500,
        message: 'Error: $e',
      );
    }
  }
}
