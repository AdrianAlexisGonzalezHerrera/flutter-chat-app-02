import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cchat_app/services/custom_services.dart';

import 'package:cchat_app/pages/pages.dart';


class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: ( context, snapshot) { 
          return Center(
          child: Text('Loading...', style: TextStyle( fontSize: 20, color: Colors.blue ),),
           );
         },
      ),
   );
  }

  Future checkLoginState( BuildContext context) async {

    final authService = Provider.of<AuthService>( context, listen: false );
    final socketService = Provider.of<SocketService>( context, listen: false );

    final autenticado = await authService.isLoggedIn();

    if ( autenticado ) {
      //TODO: Conectar Al Socket Service 
      socketService.connect();
      // Navigator.pushReplacementNamed(context, 'usuarios');
      Navigator.pushReplacement(
        context, PageRouteBuilder(
          pageBuilder: ( _, __, ___, ) => UsuariosPage(),
          transitionDuration: Duration( milliseconds: 0 ) 
        )
      );
    } else {
      // Navigator.pushReplacementNamed(context, 'login');
      Navigator.pushReplacement(
        context, PageRouteBuilder(
          pageBuilder: ( _, __, ___, ) => LoginPage(),
          transitionDuration: Duration( milliseconds: 0 ) 
        )
      );
    }

  }
}