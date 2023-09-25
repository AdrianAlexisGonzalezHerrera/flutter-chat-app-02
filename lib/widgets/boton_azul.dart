import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final String texto;
  final Function()? onPressed;

  const BotonAzul({
    super.key, 
    required this.texto, 
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStatePropertyAll(2),
              backgroundColor: MaterialStatePropertyAll(Colors.blue),
              shape: MaterialStatePropertyAll(StadiumBorder()),
            ),
            // onPressed: () { },
            onPressed: this.onPressed,
            child: Container(
              width: double.infinity,
              height: 55,
              child: Center(
                child: Text( this.texto, style: TextStyle( color: Colors.white, fontSize: 20 ) )
              ),
            ) 
          );
  }
}