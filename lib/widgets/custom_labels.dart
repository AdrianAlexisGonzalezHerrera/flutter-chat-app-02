import 'package:flutter/material.dart';


class Labels extends StatelessWidget {

  final String texto1;
  final String texto2;
  final String ruta;

  const Labels({
    super.key, 
    required this.texto1, 
    required this.texto2, 
    required this.ruta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text( this.texto1, style: TextStyle( color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300) ),
          SizedBox( height: 10 ),
          GestureDetector(
            child: Text( this.texto2, style: TextStyle( color: Colors.blue[600], fontSize: 19, fontWeight: FontWeight.bold ) ),
            onTap: () {
             Navigator.pushReplacementNamed(context, this.ruta);
            },
          ),
        ],
      ),
    );
  }
}