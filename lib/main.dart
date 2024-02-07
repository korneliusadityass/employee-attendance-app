import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project/di.dart';

import 'firebase_options.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Check if you received the link via `getInitialLink` first
    await FirebaseDynamicLinks.instance.getInitialLink();
  }
  await GetStorage.init();

  DependencyInjection mainBinding = DependencyInjection();
  mainBinding.dependencies();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(const Application()));
}
