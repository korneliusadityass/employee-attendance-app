import 'package:flutter/material.dart';
import 'package:project/src/features/home/dashboard/dashboard_page.dart';

import '../src/core/colors/color.dart';
import '../src/features/approval/approval_cuti_khusus/approval_cuti_khusus.dart';
import '../src/features/approval/approval_cuti_tahunan/approval_cuti_tahunan.dart';
import '../src/features/approval/approval_izin_3_jam/approval_izin_3_jam.dart';
import '../src/features/approval/approval_izin_sakit/approval_izin_sakit.dart';
import '../src/features/approval/approval_perjalanan_dinas/approval_perjalanan_dinas.dart';
import '../src/features/pengajuan/cuti_khusus/pengajuan_cuti_khusus.dart';
import '../src/features/pengajuan/cuti_tahunan/pengajuan_cuti_tahunan.dart';
import '../src/features/pengajuan/izin_3_jam/pengajuan_pembatalan_izin_3jam.dart';
import '../src/features/pengajuan/izin_sakit/pengajuan_pembatalan_izin_sakit_page.dart';
import '../src/features/pengajuan/perjalanan_dinas/pengajuan_perjalanan_dinas.dart';

class NavHr extends StatefulWidget {
  const NavHr({super.key});

  @override
  State<NavHr> createState() => _NavHrState();
}

class _NavHrState extends State<NavHr> {
  // ignore: unused_local_variable
  String pilihLeaves = 'Leaves';
  // ignore: unused_local_variable
  String pilihApproval = 'Approval';

  void leaves(String leaves) {
    setState(() {
      pilihLeaves = leaves;
    });
  }

  void approval(String approval) {
    setState(() {
      pilihApproval = approval;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: kDarkBlueColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
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
            ///////////////////////////// untuk dashboard
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
                    MaterialPageRoute(
                        builder: (context) =>  DashboardPage()),
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
                            builder: (context) => PengajuanIzin3Jam(),
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
                            builder: (context) => PengajuanCutiKhusus(),
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
                            builder: (context) => PengajuanPerjalananDinas(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // ////////////////////////////////////////////untuk approval
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.next_week_rounded),
                title: const Text('Approval'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Izin Sakit'),
                      onTap: () {
                        approval('Izin Sakit');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApprovalIzinSakit(),
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
                        approval('Izin 3 Jam');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApprovalIzin3Jam(),
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
                        approval('Cuti Tahunan');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApprovalCutiTahunan(),
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
                        approval('Cuti Khusus');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApprovalCutiKhusus(),
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
                        approval('Perjalanan Dinas');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                               ApprovalPerjalananDinas(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
