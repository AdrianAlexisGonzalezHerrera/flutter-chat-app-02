import 'package:cchat_app/services/custom_services.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:cchat_app/global/environment.dart';


enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;
  

  //*   Exponer El ServerStatus Para Poder 
  //*   Utilizarlo En Cualquier Parte De La Aplicación

  ServerStatus get serverStatus => this._serverStatus;
  
  IO.Socket get socket => this._socket;
  get emit => this._socket.emit;


  // SocketService(  ){  
  //   this._initConfig();
  // }

  // void _initConfig() {
  void connect() async {

    final token = await AuthService.getToken();

    // Dart client
    this._socket = IO.io( Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'x-token': token
      }
    });

 
    this._socket.on('connect', (_) {
      
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    
    this._socket.on( 'disconnect', (_) {
      
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    
    
  }


  void disconnect() {
    this._socket.disconnect();
  }

}