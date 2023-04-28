import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import 'core/database_helper.dart';

final GetIt di = GetIt.instance;

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.registerLazySingleton(() => DatabaseHelper());
  await di.get<DatabaseHelper>().init();
}
