import 'package:http/http.dart' as http;

import 'package:cchat_app/global/environment.dart';
import 'package:cchat_app/models/custom_models.dart';

import 'package:cchat_app/services/custom_services.dart';

class UsuariosService {

  Future<List<Usuario>> getUsuarios() async {

    final uri = Uri.parse('${ Environment.apiUrl }/usuarios');
    String? token = await AuthService.getToken();

    try {

      final resp = await http.get( uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        }
      );

      final usuariosResponse = usuariosResponseFromJson( resp.body );
      return usuariosResponse.usuarios;

    } catch (e) {
      return [];
    }
  }

}
