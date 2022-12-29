import 'dart:io';

import 'package:shelf/src/request.dart';
import 'package:shelf/src/response.dart';

import '../middlewares.dart';

class CorsMiddlewares extends Middlewares {
  final Map<String, String> headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PATCH, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Header':
        '${HttpHeaders.contentTypeHeader}, ${HttpHeaders.authorizationHeader}',
  };

  @override
  Future<Response> execute(Request request) async {
    // print('Inidicando crossDoMain');
    if (request.method == 'OPTIONS') {
      // print('Retornando Headres do crossDoMain');
      return Response(HttpStatus.ok, headers: headers);
    }
    // print('Executando função do crossDoMain');
    final response = await innerHandler(request);
    // print('Respondendo para o cliente do crossDoMain');
    return response.change(headers: headers);
  }
}
