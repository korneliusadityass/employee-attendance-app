import 'package:flutter/material.dart';
import 'package:project/src/features/detail/laporan/pilih_perusahaan/perusahaan_cuti_tahunan.dart';
import 'package:project/src/features/detail/laporan/pilih_perusahaan/perusahaan_izin_3_jam.dart';
import 'package:project/src/features/detail/laporan/pilih_perusahaan/perusahaan_izin_sakit.dart';
import 'package:project/src/features/home/dashboard/dashboard_page.dart';
import 'package:project/src/features/pengajuan_hr/cuti_tahunan/pengajuan_cuti_tahunan_hr.dart';

import '../src/core/colors/color.dart';
import '../src/features/approval/approval_cuti_khusus/approval_cuti_khusus.dart';
import '../src/features/approval/approval_cuti_tahunan/approval_cuti_tahunan.dart';
import '../src/features/approval/approval_izin_3_jam/approval_izin_3_jam.dart';
import '../src/features/approval/approval_izin_sakit/approval_izin_sakit.dart';
import '../src/features/approval/approval_perjalanan_dinas/approval_perjalanan_dinas.dart';
import '../src/features/detail/laporan/pilih_perusahaan/perusahaan_cuti_khusus.dart';
import '../src/features/detail/laporan/pilih_perusahaan/perusahaan_perjalanan_dinas.dart';
import '../src/features/home/master/master_approver/master_approver.dart';
import '../src/features/home/master/master_company/master_company.dart';
import '../src/features/home/master/master_jumlah_cuti_tahunan/jumlah_cuti_tahunan.dart';
import '../src/features/home/master/master_karyawan/master_karyawan.dart';
import '../src/features/pengajuan_hr/cuti_khusus/hr_pengajuan_cuti_khusus.dart';
import '../src/features/pengajuan_hr/izin_3_jam/hr_pengajuan_pembatalan_izin_3jam.dart';
import '../src/features/pengajuan_hr/izin_sakit/pengajuan_izin_sakit_hr.dart';
import '../src/features/pengajuan_hr/perjalanan_dinas/hr_pengajuan_perjalanan_dinas.dart';

class NavHr extends StatefulWidget {
  const NavHr({super.key});

  @override
  State<NavHr> createState() => _NavHrState();
}

class _NavHrState extends State<NavHr> {
  // ignore: unused_local_variable
  String pilihLaporan = 'Laporan';
  // ignore: unused_local_variable
  String pilihLeaves = 'Leaves';
  // ignore: unused_local_variable
  String pilihApproval = 'Approval';
  // ignore: unused_local_variable
  String pilihSetting = 'Setting';

  void laporan(String laporan) {
    setState(() {
      pilihLaporan = laporan;
    });
  }

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

  void setting(String setting) {
    setState(() {
      pilihSetting = setting;
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
            ///////////////////////////// untuk laporan
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
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.next_week_rounded),
                title: const Text('Laporan'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Izin Sakit'),
                      onTap: () {
                        laporan('Izin Sakit');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerusahaanIzinSakit(),
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
                        laporan('Izin 3 Jam');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerusahaanIzin3Jam(),
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
                        laporan('Cuti Tahunan');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerusahaanCutiTahunan(),
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
                        laporan('Cuti Khusus');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerusahaanCutiKhusus(),
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
                        laporan('Perjalanan Dinas');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PerusahaanPerjalananDinas(),
                          ),
                        );
                      },
                    ),
                  )
                ],
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
                            builder: (context) => PengajuanIzinSakitHR(),
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
                            builder: (context) => HRPengajuanIzin3Jam(),
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
                            builder: (context) =>
                               PengajuanCutiTahunanHR(),
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
                            builder: (context) => HRPengajuanCutiKhusus(),
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
                            builder: (context) => HRPengajuanPerjalananDinas(),
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
                            builder: (context) => ApprovalPerjalananDinas(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            // ///////////////////////////untuk setting
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.build_circle),
                title: const Text('Setting'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.location_city),
                      title: const Text('Master Company'),
                      onTap: () {
                        setting('Master Company');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MasterCompany(),
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
                      leading: const Icon(Icons.person),
                      title: const Text('Master Karyawan'),
                      onTap: () {
                        setting('Master Karyawan');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MasterKaryawan(),
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
                      leading: const Icon(Icons.event_available),
                      title: const Text('Master Approver'),
                      onTap: () {
                        setting('Master Approver');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MasterApprover(),
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
                      leading: const Icon(Icons.date_range),
                      title: const Text('Master Jumlah Cuti Tahunan'),
                      onTap: () {
                        setting('Master Jumlah Cuti Tahunan');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JumlahCutiTahunan(),
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
