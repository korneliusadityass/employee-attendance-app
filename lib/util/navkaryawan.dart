import 'package:flutter/material.dart';

import '../src/core/colors/color.dart';
import '../src/features/home/dashboard/dashboard_karyawan.dart';
import '../src/features/pengajuan/cuti_khusus/pengajuan_cuti_khusus.dart';
import '../src/features/pengajuan/cuti_tahunan/pengajuan_cuti_tahunan.dart';
import '../src/features/pengajuan/izin_3_jam/pengajuan_pembatalan_izin_3jam.dart';
import '../src/features/pengajuan/izin_sakit/pengajuan_pembatalan_izin_sakit_page.dart';
import '../src/features/pengajuan/perjalanan_dinas/pengajuan_perjalanan_dinas.dart';

class NavKaryawan extends StatefulWidget {
  const NavKaryawan({super.key});

  @override
  State<NavKaryawan> createState() => _NavKaryawanState();
}

class _NavKaryawanState extends State<NavKaryawan> {
  // ignore: unused_local_variable
  String pilihLeaves = 'Leaves';

  void leaves(String leaves) {
    setState(() {
      pilihLeaves = leaves;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: kDarkBlueColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'HR System',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: ListTile(
                leading: const Icon(Icons.castle),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboarKaryawan()),
                  );
                },
              ),
            ),
            //////////////////////////////////////////////// untuk Leaves
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.next_week_rounded),
                title: const Text('Leaves'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Izin Sakit'),
                      onTap: () {
                        leaves('Izin Sakit');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PengajuanIzinSakitPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.assignment),
                      title: const Text('Izin 3 Jam'),
                      onTap: () {
                        leaves('Izin 3 Jam');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PengajuanIzin3Jam(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Cuti Tahunan'),
                      onTap: () {
                        leaves('Cuti Tahunan');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PengajuanCutiTahunan(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Cuti Khusus'),
                      onTap: () {
                        leaves('Cuti Khusus');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PengajuanCutiKhusus(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('Perjalanan Dinas'),
                      onTap: () {
                        leaves('Perjalanan Dinas');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PengajuanPerjalananDinas(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
