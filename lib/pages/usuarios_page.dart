import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:cchat_app/services/custom_services.dart';

import 'package:cchat_app/models/usuario.dart';


class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuarioService = new UsuariosService();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  // final usuarios = [
  //   Usuario( uid: '1', nombre: 'Yenny', email: 'test1@test.com', online: true ),
  //   Usuario( uid: '2', nombre: 'Margarita', email: 'test2@test.com', online: false ),
  //   Usuario( uid: '3', nombre: 'Adrian', email: 'test3@test.com', online: true ),
  //   
  // ];

  @override
  void initState() {
    // TODO: implement initState
    this._cargarUsuarios();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    final authService   = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>( context );
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        // title: Text('Mi Nombre', style: TextStyle( color: Colors.black54), ),
        title: Text( usuario?.nombre ?? 'No-Name' , style: TextStyle( color: Colors.black54), ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            //TODO: Desconectar El Socket Server
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          }, 
          icon: Icon(Icons.exit_to_app, color: Colors.black54,)
        ),
        actions: [
          Container(
            margin: EdgeInsets.only( right: 10 ),
            child: ( socketService.serverStatus == ServerStatus.Online ) 
              ? Icon( Icons.check_circle, color: Colors.blue[400],) 
              : Icon( Icons.offline_bolt, color: Colors.red,),
          )
        ],
      ),
      // body: Center(
      //   child: Text('UsuariosPage'),
      // ),
      body: SmartRefresher(
        controller: _refreshController, 
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.blue[400] ),
          waterDropColor: Colors.blue.shade400,
        ),
        child: _listViewUsuarios(),
      )
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile( usuarios[i] ), 
      separatorBuilder: (_, i) => Divider(), 
      itemCount: usuarios.length,
    );
  }

  ListTile _usuarioListTile(Usuario usuario ) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: () {
          final chatService = Provider.of<ChatService>( context, listen: false );
          chatService.usuarioPara = usuario;
          Navigator.pushNamed(context, 'chat');
          print( usuario.nombre );
          print( usuario.email );
        },
      );
  }



  _cargarUsuarios() async{

   this.usuarios = await  usuarioService.getUsuarios();
   setState(() {});

    //void _onRefresh() async{
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    //}
  }
}