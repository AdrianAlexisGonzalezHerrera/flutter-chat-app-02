//import 'package:flutter/material.dart';
//
//
//class RegisterPage extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Center(
//        child: Text('RegisterPage'),
//     ),
//   );
//  }
//}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cchat_app/helpers/custom_helpers.dart';
import 'package:cchat_app/services/custom_services.dart';
import 'package:cchat_app/widgets/custom_widgets.dart';


class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                Logo(
                  logo: 'assets/tag-logo.png', 
                  titulo: 'Register',
                ),
                  
                _Form(),
                  
                Labels(
                  texto1: '¿Ya Tienes Una Cuentas?', 
                  texto2: 'Ingresar Ahora !!!', 
                  ruta: 'login',
                ),
                  
                Text('Términos y Condiciones De Uso', style: TextStyle( fontWeight: FontWeight.w300 ) ), 
                      
              ],
            ),
          ),
        ),
      )
   );
  }
}


class _Form extends StatefulWidget {
  // const _Form({super.key});

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameCtrl  = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>( context );
    final socketService = Provider.of<SocketService>( context );

    return Container(
      margin: EdgeInsets.only( top: 40 ),
      padding: EdgeInsets.symmetric( horizontal: 50 ),
      child: Column(
        children: [
          
          CustomInput(
            // icon: Icons.account_circle_rounded, 
            icon: Icons.perm_identity, 
            placeholder: 'Nombre', 
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          
          CustomInput(
            icon: Icons.mail_outline, 
            placeholder: 'Email', 
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          
          CustomInput(
            icon: Icons.lock_outline, 
            placeholder: 'Password', 
            // keyboardType: TextInputType.text,
            textController: passCtrl,
            isPassword: true,
          ),

          BotonAzul(
            texto: 'Crear Cuenta',
            onPressed: authService.autenticando ? () {} : () async {
              print( nameCtrl.text );
              print( emailCtrl.text );
              print( passCtrl.text );

              FocusScope.of(context).unfocus();

              final registerOk = await authService.register( nameCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim() );

              if ( registerOk == true ) {
                //TODO: Conectar A Nuestro Socket Server
                socketService.connect();

                Navigator.pushReplacementNamed( context, 'usuarios' );
              } else {
                //* Mostrar Alerta

                mostrarAlerta(context, 'Registro Incorrecto', registerOk );
              }
            }, 
          ),
        ],
      ),
    );
  }
}


