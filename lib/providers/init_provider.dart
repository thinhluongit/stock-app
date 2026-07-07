import 'package:provider/provider.dart';

import 'auth_provider.dart';
import 'home_provider.dart';
import 'user_provider.dart';

List<ChangeNotifierProvider> initMultiProvider() {
  return [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    // ChangeNotifierProvider(create: (_) => InitMainMenuProvider()),
  ];
}