import 'package:flutter/material.dart';

import 'package:cchat_app/pages/pages.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {

  'chat': (_) => ChatPage(),
  'loading': (_) => LoadingPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'usuarios': (_) => UsuariosPage(),
};