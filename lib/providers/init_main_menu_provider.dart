import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'home_provider.dart';

List<SingleChildWidget> initMultiMainMenuProvider() {
  return [
    ChangeNotifierProvider<HomeProvider>(
      create: (_) => HomeProvider(),
    ),
  ];
}