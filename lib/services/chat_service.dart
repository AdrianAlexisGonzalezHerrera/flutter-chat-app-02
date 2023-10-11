import 'package:cchat_app/global/environment.dart';
import 'package:cchat_app/models/mensajes_response.dart';
import 'package:cchat_app/services/custom_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cchat_app/models/custom_models.dart';

class ChatService with ChangeNotifier {

  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat( String usuarioID ) async {

    final uri = Uri.parse('${ Environment.apiUrl }/mensajes/$usuarioID');
    String? token = await AuthService.getToken();

    final resp = await http.get( uri,
      headers: {
        'Contet-Type': 'application/json',
        'x-token': token.toString()
      }
    );

    final mensajeResp = mensajesResponseFromJson( resp.body );

    return mensajeResp.mensajes;


  }

}