import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/src/core/routes/app_router.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/features/home/login/ganti_pw.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConfig(
      validationMessages: {
        ValidationMessage.minLength: (error) => 'Password minimal 8 karakter',
        ValidationMessage.maxLength: (error) => 'Password maksimal 20 karakter',
      },
      child: GetMaterialApp(
        title: 'Project HR',
        theme: ThemeData(textTheme: GoogleFonts.montserratTextTheme()),
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.home,
        getPages: AppRouter.pages,
      ),
    );
  }
}
