import 'dart:io';

import 'package:cchat_app/widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  List<ChatMessage> _messages = [
    // ChatMessage(texto: 'Hola Mundo', uid: '123'),
    // ChatMessage(texto: 'Hola Mundo', uid: '123'),
    // ChatMessage(texto: 'Hola Mundo', uid: '456'),
    // ChatMessage(texto: 'Hola Mundo', uid: '123'),
    // ChatMessage(texto: 'Hola Mundo', uid: '456'),
  ];


  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Te', style: TextStyle( fontSize: 12) ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox( height: 3),
            Text('Test Nombre', style: TextStyle( fontSize: 14, color: Colors.black87 ) ),
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
  
  print( texto );
  _textController.clear();
  _focusNode.requestFocus();

  final newMessage = new ChatMessage(
    texto: texto, 
    uid: '123', 
    animationController: AnimationController(vsync: this, duration: Duration( milliseconds: 400 )),
  );
  
  _messages.insert( 0, newMessage );
  newMessage.animationController.forward();

  setState(() {
    _estaEscribiendo = false;
  });
}

@override
  void dispose() {
    // TODO: Off del socket

    for( ChatMessage message in _messages ) {
      message.animationController.dispose();
    }
    
    super.dispose();
  }
}