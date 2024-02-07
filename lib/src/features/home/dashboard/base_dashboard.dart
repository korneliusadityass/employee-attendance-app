import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:project/src/core/model/user_me_model.dart';
import 'package:project/src/features/appbar/appbar_controller.dart';
import 'package:project/src/features/home/dashboard/dashboard_page.dart';

import 'dashboard_karyawan.dart';

class BaseDashboard extends StatefulWidget {
  const BaseDashboard({super.key});

  @override
  State<BaseDashboard> createState() => _BaseDashboardState();
}

class _BaseDashboardState extends State<BaseDashboard> {
  final appbarController = Get.find<AppBarController>();

  late Future<UserMeModel> _fetchUserMe;

  @override
  void initState() {
    super.initState();
    _fetchUserMe = appbarController.fetchUserMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data?.level == 'karyawan') {
              return DashboarKaryawan();
            } else {
              return DashboardPage();
            }
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          return const Center(
            child: SpinKitCircle(
              color: Colors.blue,
              size: 50.0,
            ),
          );
        },
        future: _fetchUserMe,
      ),
    );
  }
}
