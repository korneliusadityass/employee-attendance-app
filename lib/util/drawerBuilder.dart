import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../src/core/model/user_me_model.dart';
import 'navhr.dart';
import 'navkaryawan.dart';

class DrawerBuilder extends StatelessWidget {
  final Future<UserMeModel> userMe;

  const DrawerBuilder({Key? key, required this.userMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userMe,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          if (snapshot.data!.level == 'karyawan') {
            return const NavKaryawan();
          } else {
            return const NavHr();
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
    );
  }
}
