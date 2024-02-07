import 'package:get/get.dart';
import 'package:project/src/core/routes/auth_middleware.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/features/approval/approval_izin_3_jam/approval_izin_3_jam.dart';
import 'package:project/src/features/detail/Log/detail_log/detail_log_izin_3_jam.dart';
import 'package:project/src/features/detail/Log/log_izin_3_jam/log_izin_3_jam.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_izin_3_jam/detail_izin_3_jam.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_view/ijin_3_jam_detail/izin_3_jam_detail.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_view_hr/izin_3_jam_detail_hr/hr_izin_3_jam_detail.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/hr_detail_izin_3_jam/hr_detail_izin_3_jam.dart';
import 'package:project/src/features/detail/laporan/laporan_cuti_khusus/laporan_cuti_khusus.dart';
import 'package:project/src/features/detail/laporan/laporan_cuti_tahunan/laporan_cuti_tahunan.dart';
import 'package:project/src/features/detail/laporan/laporan_izin3jam/laporan_ijin_3jam.dart';
import 'package:project/src/features/detail/laporan/laporan_izin_sakit/laporan_izin_sakit.dart';
import 'package:project/src/features/detail/laporan/laporan_perjalanan_dinas/laporan_perjalanan_dinas.dart';
import 'package:project/src/features/detail/need_aprrove/detail_need_approve/detail_need_confirm_3_jam/detail_need_confirm_3_jam.dart';
import 'package:project/src/features/detail/need_aprrove/need_confirm_izin_3_jam/need_confirm_izin_3_jam.dart';
import 'package:project/src/features/home/login/lupa_pw.dart';
import 'package:project/src/features/home/master/master_company/master_company.dart';
import 'package:project/src/features/home/master/master_jumlah_cuti_tahunan/jumlah_cuti_tahunan_edit.dart';
import 'package:project/src/features/home/master/master_karyawan/master_karyawan.dart';
import 'package:project/src/features/login/login_page.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_izin_3_jam/edit_pengajuan_izin_3_jam.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_izin_sakit/edit_izin_sakit.dart';
import 'package:project/src/features/pengajuan/izin_3_jam/pengajuan_pembatalan_izin_3jam.dart';
import 'package:project/src/features/pengajuan/izin_sakit/pengajuan_pembatalan_izin_sakit_page.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_izin_3_jam/hr_edit_pengajuan_izin_3_jam.dart';
import 'package:project/src/features/pengajuan_hr/izin_3_jam/hr_pengajuan_pembatalan_izin_3jam.dart';

import '../../features/approval/approval_cuti_khusus/approval_cuti_khusus.dart';
import '../../features/approval/approval_cuti_tahunan/approval_cuti_tahunan.dart';
import '../../features/approval/approval_izin_sakit/approval_izin_sakit.dart';
import '../../features/approval/approval_perjalanan_dinas/approval_perjalanan_dinas.dart';
import '../../features/detail/Log/detail_log/detail-log_izin_sakit.dart';
import '../../features/detail/Log/detail_log/detail_log_cuti_khusus.dart';
import '../../features/detail/Log/detail_log/detail_log_cuti_tahunan.dart';
import '../../features/detail/Log/detail_log/detail_log_perjalanan_dinas.dart';
import '../../features/detail/Log/log_cuti_khusus/log_cuti_khusus.dart';
import '../../features/detail/Log/log_cuti_tahunan/log_cuti_tahunan.dart';
import '../../features/detail/Log/log_izin_sakit/log_izin_sakit.dart';
import '../../features/detail/Log/log_perjalanan_dinas/log_perjalanan_dinas.dart';
import '../../features/detail/detail_pengajuan/detail_cuti_khusus/detail_cuti_khusus.dart';
import '../../features/detail/detail_pengajuan/detail_cuti_tahunan/detail_cuti_tahunan.dart';
import '../../features/detail/detail_pengajuan/detail_izin_sakit/detail_izin_sakit.dart';
import '../../features/detail/detail_pengajuan/detail_perjalanan_dinas/detail_perjalanan_dinas.dart';
import '../../features/detail/detail_pengajuan/detail_view/cuti_khusus_detail/cuti_khusus_detail.dart';
import '../../features/detail/detail_pengajuan/detail_view/cuti_tahunan_detail/cuti_tahunan_detail.dart';
import '../../features/detail/detail_pengajuan/detail_view/izin_sakit_detail/izin_sakit_detail_view.dart';
import '../../features/detail/detail_pengajuan/detail_view/perjalanan_dinas_detail/perjalanan_dinas_detail.dart';
import '../../features/detail/detail_pengajuan_hr/detail_cuti_khusus/hr_detail_cuti_khusus.dart';
import '../../features/detail/detail_pengajuan_hr/detail_cuti_tahunan/detail_cuti_tahunan_hr.dart';
import '../../features/detail/detail_pengajuan_hr/detail_izin_sakit_hr/detail_izin_sakit_hr.dart';
import '../../features/detail/detail_pengajuan_hr/detail_perjalanan_dinas/hr_detail_perjalanan_dinas.dart';
import '../../features/detail/detail_pengajuan_hr/detail_view_hr/cuti_khusus_detail_hr/cuti_khusus_detail_hr.dart';
import '../../features/detail/detail_pengajuan_hr/detail_view_hr/cuti_tahunan_detail_hr/cuti_tahunan_detail_hr.dart';
import '../../features/detail/detail_pengajuan_hr/detail_view_hr/izin_sakit_detail_hr/izin_sakit_detail_hr.dart';
import '../../features/detail/detail_pengajuan_hr/detail_view_hr/perjalanan_dinas_detail_hr/perjalanan_dinas_detail_hr.dart';
import '../../features/detail/need_aprrove/detail_need_approve/detail_need_confirm_cuti_khusus/detail_need_confirm_cuti_khusus.dart';
import '../../features/detail/need_aprrove/detail_need_approve/detail_need_confirm_cuti_tahunan/detail_need_confirm_cuti_tahunan.dart';
import '../../features/detail/need_aprrove/detail_need_approve/detail_need_confirm_izin_sakit/detail_need_confirm_izin_sakit.dart';
import '../../features/detail/need_aprrove/detail_need_approve/detail_need_confirm_perjalanan_dinas/detail_need_confirm_perjalanan_dinas.dart';
import '../../features/detail/need_aprrove/need_confirm_cuti_khusus/need_confirm_cuti_khusus.dart';
import '../../features/detail/need_aprrove/need_confirm_cuti_tahunan/need_confirm_cuti_tahunan.dart';
import '../../features/detail/need_aprrove/need_confirm_izin_sakit/need_confirm_Izin_sakit.dart';
import '../../features/detail/need_aprrove/need_confirm_perjalanan_dinas/need_confirm_perjalanan_dinas.dart';
import '../../features/home/dashboard/base_dashboard.dart';
import '../../features/home/master/master_approver/master_approver.dart';
import '../../features/home/master/master_jumlah_cuti_tahunan/jumlah_cuti_tahunan.dart';
import '../../features/pengajuan/cuti_khusus/pengajuan_cuti_khusus.dart';
import '../../features/pengajuan/cuti_tahunan/pengajuan_cuti_tahunan.dart';
import '../../features/pengajuan/edit_pengajuan/edit_pengajuan_cuti_khusus/edit_cuti_khusus.dart';
import '../../features/pengajuan/edit_pengajuan/edit_pengajuan_cuti_tahunan/edit_cuti_tahunan.dart';
import '../../features/pengajuan/edit_pengajuan/edit_pengajuan_perjalanan_dinas/edit_perjalanan_dinas.dart';
import '../../features/pengajuan/perjalanan_dinas/pengajuan_perjalanan_dinas.dart';
import '../../features/pengajuan_hr/cuti_khusus/hr_pengajuan_cuti_khusus.dart';
import '../../features/pengajuan_hr/cuti_tahunan/pengajuan_cuti_tahunan_hr.dart';
import '../../features/pengajuan_hr/hr_edit_pengajuan/hr_cuti_tahunan/hr_edit_cuti_tahunan.dart';
import '../../features/pengajuan_hr/hr_edit_pengajuan/hr_edit_cuti_khusus/hr_edit_cuti_khusus.dart';
import '../../features/pengajuan_hr/hr_edit_pengajuan/hr_edit_izin_sakit/hr_edit_izin_sakit.dart';
import '../../features/pengajuan_hr/hr_edit_pengajuan/hr_edit_perjalanan_dinas/hr_edit_perjalanan_dinas.dart';
import '../../features/pengajuan_hr/izin_sakit/pengajuan_izin_sakit_hr.dart';
import '../../features/pengajuan_hr/perjalanan_dinas/hr_pengajuan_perjalanan_dinas.dart';

abstract class AppRouter {
  static final pages = [
    GetPage(
        name: Routes.home,
        page: () => const BaseDashboard(),
        middlewares: [AuthMiddleware(Get.find())]),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: Routes.detailIzin3Jam,
      page: () => const DetailIzin3Jam(),
    ),
    GetPage(
      name: Routes.pageCutiKhusus,
      page: () => const PengajuanCutiKhusus(),
    ),
    GetPage(
      name: Routes.detailCutiKhusus,
      page: () => const DetailCutiKhusus(),
    ),
    GetPage(
      name: Routes.cutiKhususDetail,
      page: () => const CutiKhususDetail(),
    ),
    GetPage(
      name: Routes.cutiKhususEdit,
      page: () => const EditCutiKhusus(),
    ),
    GetPage(
      name: Routes.pageHrCutiKhusus,
      page: () => const HRPengajuanCutiKhusus(),
    ),
    GetPage(
      name: Routes.detailHrCutiKhusus,
      page: () => const HRDetailCutiKhusus(),
    ),
    GetPage(
      name: Routes.cutiKhususHrEdit,
      page: () => const HREditCutiKhusus(),
    ),
    GetPage(
      name: Routes.cutiKhususHrDetail,
      page: () => const HRCutiKhususDetail(),
    ),
    GetPage(
      name: Routes.needConfirmCutiKhusus,
      page: () => NeedConfirmCutiKhusus(),
    ),
    GetPage(
      name: Routes.detailNeedConfirmCutiKhusus,
      page: () => const DetailNeedConfirmCutiKhusus(),
    ),
    GetPage(
      name: Routes.pageApprovalCutiKhusus,
      page: () => ApprovalCutiKhusus(),
    ),
    GetPage(
      name: Routes.pageLogCutiKhusus,
      page: () => LogCutiKhusus(),
    ),
    GetPage(
      name: Routes.detailLogCutiKhusus,
      page: () => const CutiKhususDetailLog(),
    ),
    GetPage(
      name: Routes.pagePerjalananDinas,
      page: () => const PengajuanPerjalananDinas(),
    ),
    GetPage(
      name: Routes.detailPerjalananDinas,
      page: () => const DetailPerjalananDinas(),
    ),
    GetPage(
      name: Routes.perjalananDinasDetail,
      page: () => const PerjalananDinasDetail(),
    ),
    GetPage(
      name: Routes.perjalananDinasEdit,
      page: () => const EditPerjalananDinas(),
    ),
    GetPage(
      name: Routes.pageHrPerjalananDinas,
      page: () => const HRPengajuanPerjalananDinas(),
    ),
    GetPage(
      name: Routes.detailHrPerjalananDinas,
      page: () => const HRDetailPerjalananDinas(),
    ),
    GetPage(
        name: Routes.perjalananDinasHrEdit,
        page: () => const HREditPerjalananDinas()),
    GetPage(
      name: Routes.perjalananDinasHrDetail,
      page: () => const HRPerjalananDinasDetail(),
    ),
    GetPage(
      name: Routes.needConfirmPerjalananDinas,
      page: () => NeedConfirmPerjalananDinas(),
    ),
    GetPage(
      name: Routes.detailNeedConfirmPerjalananDinas,
      page: () => const DetailNeedConfirmPerjalananDinas(),
    ),
    GetPage(
      name: Routes.pageApprovalPerjalananDinas,
      page: () => ApprovalPerjalananDinas(),
    ),
    GetPage(
      name: Routes.pageLogPerjalananDinas,
      page: () => LogPerjalananDinas(),
    ),
    GetPage(
      name: Routes.detailLogPerjalananDinas,
      page: () => const PerjalananDinasDetailLog(),
    ),
    GetPage(
      name: Routes.detailCutiTahunan,
      page: () => const DetailCutiTahunan(),
    ),
    GetPage(
      name: Routes.needConfirmCutiTahunan,
      page: () => NeedConfirmCutiTahunan(),
    ),
    GetPage(
      name: Routes.detailNeedConfirmCutiTahunan,
      page: () => const DetailNeedConfirmCutiTahunan(),
    ),
    GetPage(
      name: Routes.pageApprovalCutiTahunan,
      page: () => ApprovalCutiTahunan(),
    ),
    GetPage(
      name: Routes.pageLogCutiTahunan,
      page: () => LogCutiTahunan(),
    ),
    GetPage(
      name: Routes.detailLogCutiTahunan,
      page: () => const CutiTahunanDetailLog(),
    ),
    GetPage(
      name: Routes.detailIzinSakitt,
      page: () => const DetailIzinSakit(),
    ),
    GetPage(
      name: Routes.cutiTahunanDetail,
      page: () => const CutiTahunanDetail(),
    ),
    GetPage(
      name: Routes.cutiTahunanHrDetail,
      page: () => const CutiTahunanDetailHR(),
    ),
    GetPage(
      name: Routes.detailIzinSakitt,
      page: () => const DetailIzinSakitViewTabel(),
    ),
    GetPage(
      name: Routes.izinSakitHrDetail,
      page: () => const DetailIzinSakitViewTabelHR(),
    ),
    GetPage(
      name: Routes.hrDetailIzinSakitt,
      page: () => const DetailIzinSakitHRInput(),
    ),
    GetPage(
      name: Routes.pageIzinSakitt,
      page: () => PengajuanIzinSakitPage(),
    ),
    GetPage(
      name: Routes.pageIzinSakittHr,
      page: () => const PengajuanIzinSakitHR(),
    ),
    GetPage(
      name: Routes.editIzinSakitt,
      page: () => const EditPengajuanIzinSakit(),
    ),
    GetPage(
      name: Routes.pageCutiTahunanHr,
      page: () => const PengajuanCutiTahunanHR(),
    ),
    GetPage(
      name: Routes.hrDetailCutiTahunan,
      page: () => const DetailCutiTahunanHR(),
    ),
    GetPage(
      name: Routes.editIzinSakittHr,
      page: () => const EditIzinSakitHR(),
    ),
    GetPage(
      name: Routes.needConfirmIzinSakit,
      page: () => NeedConfirmIzinSakit(),
    ),
    GetPage(
      name: Routes.detailNeedConfirmIzinSakit,
      page: () => const DetailNeedConfirmIzinSakit(),
    ),
    GetPage(
      name: Routes.pageApprovalIzinSakit,
      page: () => ApprovalIzinSakit(),
    ),
    GetPage(
      name: Routes.pageLogIzinSakit,
      page: () => LogIzinSakit(),
    ),
    GetPage(
      name: Routes.detailLogIzinSakit,
      page: () => const IzinSakitDetailLog(),
    ),
    GetPage(
      name: Routes.editCutiTahunan,
      page: () => const EditCutiTahunan(),
    ),
    GetPage(
      name: Routes.editCutiTahunanHr,
      page: () => const EditCutiTahunanHR(),
    ),
    GetPage(
      name: Routes.pageCutiTahunan,
      page: () => PengajuanCutiTahunan(),
    ),
    GetPage(
      name: Routes.izinDetail3Jam,
      page: () => const Izin3JamDetail(),
    ),
    GetPage(
      name: Routes.editIzinDetail3Jam,
      page: () => const EditPengajuanIzin3Jam(),
    ),
    GetPage(
      name: Routes.detailIzin3Jam,
      page: () => const DetailIzin3Jam(),
    ),
    GetPage(
      name: Routes.masterCompany,
      page: () => MasterCompany(),
    ),
    GetPage(
      name: Routes.masterKaryawan,
      page: () => MasterKaryawan(),
    ),
    GetPage(
      name: Routes.masterApprover,
      page: () => MasterApprover(),
    ),
    GetPage(
      name: Routes.needConfirmIzin3Jam,
      page: () => NeedConfirmIzin3Jam(),
    ),
    GetPage(
      name: Routes.detailNeedConfirm3Jam,
      page: () => const DetailNeedConfirm3Jam(),
    ),
    GetPage(
      name: Routes.pageApprovalIzin3Jam,
      page: () => ApprovalIzin3Jam(),
    ),
    GetPage(
      name: Routes.pageLogIzin3Jam,
      page: () => LogIzin3jam(),
    ),
    GetPage(
      name: Routes.detailLogIzin3Jam,
      page: () => const DetailLogIzin3Jam(),
    ),
    GetPage(
      name: Routes.pageLaporanCutiTahunan,
      page: () => LaporanCutiTahunan(),
    ),
    GetPage(
      name: Routes.pageLaporanCutiKhusus,
      page: () => LaporanCutiKhusus(),
    ),
    GetPage(
      name: Routes.pageLaporanPerjalananDinas,
      page: () => LaporanPerjalananDinas(),
    ),
    GetPage(
      name: Routes.pageHrDetailIzin3Jam,
      page: () => const HRDetailIzin3Jam(),
    ),
    GetPage(
      name: Routes.pageHrPengajuanIzin3Jam,
      page: () => HRPengajuanIzin3Jam(),
    ),
    GetPage(
      name: Routes.pageHrIzin3JamDetail,
      page: () => const HRIzin3JamDetail(),
    ),
    GetPage(
      name: Routes.pageHrEditIzin3Jam,
      page: () => const HREditPengajuanIzin3Jam(),
    ),
    GetPage(
      name: Routes.pageIzin3Jam,
      page: () => const PengajuanIzin3Jam(),
    ),
    GetPage(
      name: Routes.pageLaporanIzin3Jam,
      page: () => LaporanIzin3Jam(),
    ),
    GetPage(
      name: Routes.pageLaporanIzinSakit,
      page: () => LaporanIzinSakit(),
    ),
    GetPage(
      name: Routes.editMasterJumlahCutiTahunan,
      page: () => const EditMasterCutiTahunan(),
    ),
    GetPage(
      name: Routes.lupaPw,
      page: () => LupaPw(),
    ),
    GetPage(
      name: Routes.masterJumlahCutiTahunanPage,
      page: () => JumlahCutiTahunan(),
    ),
  ];
}
