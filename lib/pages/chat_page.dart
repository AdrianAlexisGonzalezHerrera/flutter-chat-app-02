import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:cchat_app/models/custom_models.dart';
import 'package:cchat_app/services/custom_services.dart';
import 'package:cchat_app/widgets/custom_widgets.dart';


class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  late AuthService authService;
  late ChatService chatService;
  late SocketService socketService;

  List<ChatMessage> _messages = [
    // ChatMessage(texto: 'Hola Mundo', uid: '123'),
    // ChatMessage(texto: 'Hola Mundo', uid: '123'),
    // ChatMessage(texto: 'Hola Mundo', uid: '456'),
    // ChatMessage(texto: 'Hola Mundo', uid: '123'),
    // ChatMessage(texto: 'Hola Mundo', uid: '456'),
  ];


  bool _estaEscribiendo = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.authService   = Provider.of<AuthService>(context, listen: false );
    this.chatService   = Provider.of<ChatService>(context, listen: false );
    this.socketService = Provider.of<SocketService>(context, listen: false );


    this.socketService.socket.on( 'mensaje-personal' , _escuchandoMensaje );

    _cargarHistorial( this.chatService.usuarioPara.uid );
  }

  void _cargarHistorial( String usuarioID ) async {

    List<Mensaje> chat = await this.chatService.getChat(usuarioID);

    //print( chat );
    final history = chat.map((m) => new ChatMessage(
      texto: m.mensaje, 
      uid: m.de, 
      animationController: new AnimationController( vsync: this, duration: Duration( milliseconds: 0))..forward(),
    ));

    setState(() {
      _messages.insertAll( 0, history );
    });

  }

  void _escuchandoMensaje( dynamic payload ) {

    // print( 'Tengo Mensaje!!! $payload' );
    // print( payload['mensaje']);

    ChatMessage message = new ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController( vsync: this, duration: Duration( milliseconds: 300))
    );

    setState(() {
      _messages.insert( 0, message );
    });

    message.animationController.forward();

  }

  @override
  Widget build(BuildContext context) {

    //final chatService = Provider.of<ChatService>(context);
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text( usuarioPara.nombre.substring(0,2), style: TextStyle( fontSize: 12) ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox( height: 3),
            Text( usuarioPara.nombre, style: TextStyle( fontSize: 14, color: Colors.black87 ) ),
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),

      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                // itemBuilder: ( _,i ) => Text('~$i'),
                itemCount: _messages.length,
                itemBuilder: ( _,i ) => _messages[i],
                reverse: true,
              )
            ),

            Divider( height: 1 ),

            // TODO: Caja De Texto
            Container(
              color: Colors.white,
              height: 50,
              child: _inputChat(),
            )
          ],
        ),
      ),

   );
  }

Widget _inputChat() {

  return SafeArea(
    child: Container(
      margin: EdgeInsets.symmetric( horizontal: 8.0 ),
      child: Row(
        children: [
          Flexible(
            child: TextField(
             controller:  _textController,
              //onSubmitted: (_) {},
              //onSubmitted: _handleSubmit, //(this._textController.text),
              onSubmitted: _handleSubmit, // ( _textController.text), //(this._textController.text),
              onChanged: ( texto ) {
                // TODO: Cuando Hay Un Valor, Para Poder Postear
                setState(() {
                  if ( texto.trim().length > 0 ) {
                    _estaEscribiendo = true;
                  } else {
                    _estaEscribiendo = false;
                  }
                });
                
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Enviar Mensaje'
              ),
              focusNode: _focusNode,
            ) 
          ),

          //* Botón De Enviar
          Container(
            margin: EdgeInsets.symmetric( horizontal: 4.0 ),
            child: Platform.isIOS 
              ? CupertinoButton(
                child: Text('Enviar'), 
                onPressed: _estaEscribiendo
                     ? () => _handleSubmit( _textController.text.trim() )
                     : null, 
              )
              
              : Container(
                margin: EdgeInsets.symmetric( horizontal: 4.0 ),
                child: IconTheme(
                  data: IconThemeData( color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon( Icons.send ),
                    // onPressed: null, 
                    onPressed: _estaEscribiendo
                     ? () => _handleSubmit( _textController.text.trim() )
                     : null, 
                  ),
                ),
              ),
          ),
          
        ],
      ),
    )
  );

}

_handleSubmit( String texto ) {

  if ( texto.length == 0 ) return;
  
  // print( texto );
  _textController.clear();
  _focusNode.requestFocus();
  
  
  final newMessage = new ChatMessage(
    texto: texto, 
    // uid: '123', 
    uid: authService.usuario!.uid ,
    animationController: AnimationController(vsync: this, duration: Duration( milliseconds: 400 )),
  );
  
  _messages.insert( 0, newMessage );
  newMessage.animationController.forward();

  setState(() { _estaEscribiendo = false; });
  //final de = this.authService.usuario?.uid;
  //final para = this.chatService.usuarioPara.uid;
  //
  //print('de: $de' );
  //print('para: $para');

  this.socketService.emit('mensaje-personal', {
   'de': this.authService.usuario?.uid,
   'para': this.chatService.usuarioPara.uid,
   'mensaje': texto
  });
  
}

@override
  void dispose() {
    // TODO: Off del socket

    for( ChatMessage message in _messages ) {
      message.animationController.dispose();
    }
    
    this.socketService.socket.off( 'mensaje-personal' );
    super.dispose();
  }
}