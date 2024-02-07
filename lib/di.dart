import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/src/core/helper/auth_pref_helper.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/controller_master_jumlah_cuti_tahunan.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/generate_controller_master_cuti_tahunan.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/generate_services_master_cuti_tahunan.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/services_master_jumlah_cuti_tahunan.dart';
import 'package:project/src/core/services/approval/izin_3_jam_service/hr_approve_izin_3_jam_service.dart';
import 'package:project/src/core/services/approval/izin_3_jam_service/hr_get_detail_izin_3_jam_services.dart';
import 'package:project/src/core/services/approval/izin_3_jam_service/hr_get_list_izin_3_jam_service.dart';
import 'package:project/src/core/services/approval/izin_3_jam_service/hr_list_attachment_izin_3_jam_service.dart';
import 'package:project/src/core/services/approval/izin_3_jam_service/hr_refused_izin_3_jam_service.dart';
import 'package:project/src/core/services/change_password_service.dart';
import 'package:project/src/core/services/dashboard/dashboard_hr/dashboard_hr_services.dart';
import 'package:project/src/core/services/dashboard/dashboard_hr/dashboard_saya_controller.dart';
import 'package:project/src/core/services/dashboard/dashboard_hr/dashboard_saya_services.dart';
import 'package:project/src/core/services/dashboard/dashboard_hr/dashboardhr_controler.dart';
import 'package:project/src/core/services/dashboard/dashboard_karyawan/dashboard_karyawan_controller.dart';
import 'package:project/src/core/services/dashboard/dashboard_karyawan/dashboard_karyawan_services.dart';
import 'package:project/src/core/services/dio_clients.dart';
import 'package:project/src/core/services/laporan/cuti_khusus_service/export_laporan_cuti_khusus_service.dart';
import 'package:project/src/core/services/laporan/cuti_khusus_service/get_laporan_cuti_khusus_service.dart';
import 'package:project/src/core/services/laporan/cuti_tahunan_service/export_laporan_cuti_tahunan_service.dart';
import 'package:project/src/core/services/laporan/cuti_tahunan_service/get_laporan_cuti_tahunan_service.dart';
import 'package:project/src/core/services/laporan/izin_3jam_service/export_laporan_izin_3jam_service.dart';
import 'package:project/src/core/services/laporan/izin_3jam_service/get_laporan_izin_3jam_service.dart';
import 'package:project/src/core/services/laporan/izin_sakit_service/export_laporan_izin_sakit_service.dart';
import 'package:project/src/core/services/laporan/izin_sakit_service/get_laporan_izin_sakit_service.dart';
import 'package:project/src/core/services/laporan/perjalanan_dinas_service/export_laporan_perjalanan_dinas_service.dart';
import 'package:project/src/core/services/laporan/perjalanan_dinas_service/get_laporan_perjalanan_dinas_service.dart';
import 'package:project/src/core/services/laporan/pilih_perusahaan/list_perusahaan_service.dart';
import 'package:project/src/core/services/login/login_service.dart';
import 'package:project/src/core/services/lupa_password/controller_lupa_password.dart';
import 'package:project/src/core/services/lupa_password/services_lupa_password.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverdelete_controller.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverdelete_service.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverdetail_controller.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverdetail_service.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproveredit_controller.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproveredit_service.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverinput_controller.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverinput_service.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverlist_controller.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverlist_service.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanydelete_controller.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanydelete_service.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanydetail_controller.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanydetail_service.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanyedit_controller.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanyedit_service.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanyinput_controller.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanyinput_service.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanylist_controller.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanylist_service.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawandelete_controller.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawandelete_service.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawandetail_controller.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawandetail_service.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawanedit_controller.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawanedit_service.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawaninput_controller.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawaninput_service.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawanlist_controller.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawanlist_service.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/cancelled_cuti_tahunan_services.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/cuti_tahunan_confirm_services.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/cuti_tahunan_detail_services.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/cuti_tahunan_input_services.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/cuti_tahunan_list_services.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/data_edit_cuti_tahunan_services.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/delete_attachment_cuti_tahunan_services.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/delete_cuti_tahunan_services.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/edit_cuti_tahunan_services.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/get_attachment_cuti_tahunan_services.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/input_attachment_cuti_tahunan_services.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/total_cuti_tahunan_services.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/cancelled_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/data_edit_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/delete_attachment_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/delete_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/edit_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/get_attachment_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/input_attachment_izin_3_jam.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/izin_3_jam_confirm_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/izin_3_jam_list_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/cancelled_izin_sakit_services.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/confirm_izin_sakit_services.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/data_edit_izin_sakit_services.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/delete_attachement_izin_sakit_services.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/delete_izin_sakit_services.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/edit_izin_sakit_services.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/get_attachement_izin_sakit_services.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/input_attachment_izin_sakit.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/izin_sakit_input_services.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/izin_sakit_list_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/cuti_tahunan_servicess/cancelled_cuti_tahunan_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/cuti_tahunan_servicess/confirm_cuti_tahunan_hr_service.dart';
import 'package:project/src/core/services/pengajuan_hr_services/cuti_tahunan_servicess/data_edit_cuti_tahunan_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/cuti_tahunan_servicess/delete_attachment_cutitahunan_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/cuti_tahunan_servicess/delete_cuti_tahunan_hr_service.dart';
import 'package:project/src/core/services/pengajuan_hr_services/cuti_tahunan_servicess/edit_cuti_tahunan_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/cuti_tahunan_servicess/get_attachment_cuti_tahunan_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/cuti_tahunan_servicess/input_attachment_cuti_tahunan_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/cuti_tahunan_servicess/input_cuti_tahunan_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/cuti_tahunan_servicess/list_cuti_tahunan_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_3_jam_services/hr_cancelled_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_3_jam_services/hr_confirm_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_3_jam_services/hr_data_edit_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_3_jam_services/hr_delete_attachment_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_3_jam_services/hr_delete_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_3_jam_services/hr_edit_ijin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_3_jam_services/hr_input_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_3_jam_services/hr_izin_3_jam_list_service.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_3_jam_services/hr_list_karyawan_service.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_sakit_services/canceled_izin_sakit_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_sakit_services/confirm_izin_sakit_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_sakit_services/data_edit_izin_sakit_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_sakit_services/delete_attachement_izin_sakit_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_sakit_services/delete_izin_sakit_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_sakit_services/edit_izin_sakit_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_sakit_services/get_attachment_izin_sakit_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_sakit_services/hr_list_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_sakit_services/input_attachment_izin_sakit_hr_services.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_sakit_services/input_izin_sakit_hr_services.dart';
import 'package:project/src/features/approval/approval_izin_3_jam/widgets/list_izin_3_jam_approval_controller.dart';
import 'package:project/src/features/change_password/change_password_controller.dart';
import 'package:project/src/features/detail/Log/log_izin_3_jam/widgets/log_izin_3_jam_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_cuti_tahunan/widget/cancel_cuti_tahunan_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_cuti_tahunan/widget/confirm_cuti_tahunan_controler.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_cuti_tahunan/widget/delete_cuti_tahunan_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_cuti_tahunan/widget/detail_cuti_tahunan_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_cuti_tahunan/widget/input_attachment_cuti_tahunan_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_izin_3_jam/widgets/detail_izin_3_jam_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_izin_sakit/widget/cancel_izin_sakit_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_izin_sakit/widget/confirm_izin_sakit_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_izin_sakit/widget/delete_izin_sakit_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_izin_sakit/widget/detail_izin_sakit_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_izin_sakit/widget/input_attachment_izin_sakit_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_view/cuti_tahunan_detail/widget/cuti_tahunan_detail_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_view/ijin_3_jam_detail/widget/izin_3_jam_detail_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_view/izin_sakit_detail/widget/izin_sakit_detail_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/cancel_cuti_tahunan_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/confirm_cuti_tahunan_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/delete_cuti_tahunan_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/detail_cuti_tahunan_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/input_attachment_cuti_tahunan_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_izin_sakit_hr/widget/cancel_izin_sakit_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_izin_sakit_hr/widget/confirm_izin_sakit_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_izin_sakit_hr/widget/delete_izin_sakit_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_izin_sakit_hr/widget/detail_izin_sakit_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_izin_sakit_hr/widget/input_attachment_izin_sakit_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_view_hr/cuti_tahunan_detail_hr/widgets/cuti_tahunan_detail_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_view_hr/izin_3_jam_detail_hr/widgets/hr_izin_3_jam_detail_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/hr_detail_izin_3_jam/widgets/hr_detail_izin_3_jam_controller.dart';
import 'package:project/src/features/detail/laporan/laporan_cuti_khusus/widgets/laporan_cuti_khusus_controller.dart';
import 'package:project/src/features/detail/laporan/laporan_cuti_tahunan/widgets/laporan_cuti_tahunan_controller.dart';
import 'package:project/src/features/detail/laporan/laporan_izin3jam/widgets/controller_laporan_izin3jam.dart';
import 'package:project/src/features/detail/laporan/laporan_izin_sakit/widgets/controller_laporan_sakit.dart';
import 'package:project/src/features/detail/laporan/laporan_perjalanan_dinas/widgets/laporan_perjalanan_dinas_controller.dart';
import 'package:project/src/features/detail/laporan/pilih_perusahaan/perusahaan_controller.dart';
import 'package:project/src/features/detail/need_aprrove/detail_need_approve/detail_need_confirm_3_jam/widgets/detail_need_confirm_3_jam_controller.dart';
import 'package:project/src/features/detail/need_aprrove/detail_need_approve/detail_need_confirm_cuti_khusus/widgets/detail_need_confirm_cuti_khusus_controller.dart';
import 'package:project/src/features/detail/need_aprrove/need_confirm_izin_3_jam/widgets/need_confirm_izin_3_jam_controller.dart';
import 'package:project/src/features/login/login_controller.dart';
import 'package:project/src/features/pengajuan/cuti_tahunan/widgets/cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan/cuti_tahunan/widgets/cuti_tahunan_input_controller.dart';
import 'package:project/src/features/pengajuan/cuti_tahunan/widgets/sisa_kuota_cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_cuti_tahunan/widget/delete_attachment_edit_cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_cuti_tahunan/widget/edit_cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_cuti_tahunan/widget/get_attachment_cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_cuti_tahunan/widget/input_attachment_cuti_tahunan_confirm_approve_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_izin_3_jam/widgets/edit_pengajuan_izin_3_jam_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_izin_sakit/widget/delete_attachment_edit_izin_sakit_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_izin_sakit/widget/edit_izin_sakit_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_izin_sakit/widget/get_attachment_izin_sakit_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_izin_sakit/widget/input_attachment_izin_sakit_confirm_approve_controller.dart';
import 'package:project/src/features/pengajuan/izin_3_jam/widgets/pengajuan_izin_3_jam_controller.dart';
import 'package:project/src/features/pengajuan/izin_sakit/widgets/izin_sakit_input_controller.dart';
import 'package:project/src/features/pengajuan/izin_sakit/widgets/izin_sakit_list_controller.dart';
import 'package:project/src/features/pengajuan_hr/cuti_tahunan/widget/hr_cuti_tahunan_list_controller.dart';
import 'package:project/src/features/pengajuan_hr/cuti_tahunan/widget/hr_input_cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_cuti_tahunan/widget/data_pengajuan_cuti-tahunan_hr_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_cuti_tahunan/widget/delete_attachment_cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_cuti_tahunan/widget/edit_cuti_tahunan_hr_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_cuti_tahunan/widget/get_attachment_cuti_tahunan_hr_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_cuti_tahunan/widget/input_attachment_cuti_tahunan_hr_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_izin_3_jam/widgets/hr_edit_pengajuan_izin_3_jam_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_izin_sakit/widget/data_pengajuan_izin_sakit_hr_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_izin_sakit/widget/delete_attachment_izin_sakit_hr_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_izin_sakit/widget/edit_izin_sakit_hr_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_izin_sakit/widget/get_attachment_izin_sakit_hr_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_izin_sakit/widget/input_attachment_izin_sakit_hr_confirm_approve_controller.dart';
import 'package:project/src/features/pengajuan_hr/izin_3_jam/widgets/hr_pengajuan_pembatalan_izin_3_jam_controller.dart';
import 'package:project/src/features/pengajuan_hr/izin_sakit/widget/hr_izin_sakit_input_controller.dart';
import 'package:project/src/features/pengajuan_hr/izin_sakit/widget/hr_izin_sakit_list_controller.dart';

import 'src/core/model/master/jumlah_cuti_tahunan/controller_detail_data_master_cuti_tahunan.dart';
import 'src/core/model/master/jumlah_cuti_tahunan/controller_edit_master_cuti_tahunan.dart';
import 'src/core/model/master/jumlah_cuti_tahunan/service_detail_data_master_cuti_tahunan.dart';
import 'src/core/model/master/jumlah_cuti_tahunan/services_edit_master_jumlah_cuti_tahunan.dart';
import 'src/core/services/appbar/appbar_service.dart';
import 'src/core/services/approval/cuti_khusus_service/cuti_khusus_approval_service.dart';
import 'src/core/services/approval/cuti_tahunan_services/cuti_tahunan_approval_service.dart';
import 'src/core/services/approval/izin_sakit_services/izin_sakit_approval_service.dart';
import 'src/core/services/approval/perjalanan_dinas_service/perjalanan_dinas_approval_service.dart';
import 'src/core/services/pengajuan/cuti_khusus_service/pengajuan_cuti_khusus_service.dart';
import 'src/core/services/pengajuan/cuti_tahunan_services/download_attachment_cuti_tahunan_services.dart';
import 'src/core/services/pengajuan/izin_3_jam_service/download_attachment_izin_3_jam_service.dart';
import 'src/core/services/pengajuan/izin_sakit_services/download_attachement_izin_sakit_services.dart';
import 'src/core/services/pengajuan/perjalanan_dinas_service/pengajuan_perjalanan_dinas_service.dart';
import 'src/core/services/pengajuan_hr_services/cuti_khusus/hr_cuti_khusus_service.dart';
import 'src/core/services/pengajuan_hr_services/perjalanan_dinas/hr_perjalanan_dinas_service.dart';
import 'src/features/appbar/appbar_controller.dart';
import 'src/features/approval/approval_cuti_khusus/widgets/cuti_khusus_approval_controller.dart';
import 'src/features/approval/approval_cuti_tahunan/widgets/cuti_tahunan_approval_controller.dart';
import 'src/features/approval/approval_izin_sakit/widgets/izin_sakit_approval_controller.dart';
import 'src/features/approval/approval_perjalanan_dinas/widgets/perjalanan_dinas_approval_controller.dart';
import 'src/features/detail/Log/log_cuti_khusus/widgets/log_cuti_khusus_controller.dart';
import 'src/features/detail/Log/log_cuti_tahunan/widgets/log_cuti_tahunan_controller.dart';
import 'src/features/detail/Log/log_izin_sakit/widgets/log_izin_sakit_controller.dart';
import 'src/features/detail/Log/log_perjalanan_dinas/widgets/log_perjalanan_dinas_controller.dart';
import 'src/features/detail/detail_pengajuan/detail_cuti_khusus/widgets/detail_cuti_khusus_controller.dart';
import 'src/features/detail/detail_pengajuan/detail_perjalanan_dinas/widgets/detail_perjalanan_dinas_controller.dart';
import 'src/features/detail/detail_pengajuan/detail_view/cuti_khusus_detail/widget/cuti_khusus_detail_controller.dart';
import 'src/features/detail/detail_pengajuan/detail_view/cuti_tahunan_detail/widget/cuti_tahunan_download_attachment_controller.dart';
import 'src/features/detail/detail_pengajuan/detail_view/izin_sakit_detail/widget/izin_sakit_download_attachment_modal.dart';
import 'src/features/detail/detail_pengajuan/detail_view/perjalanan_dinas_detail/widget/perjalanan_dinas_detail_controller.dart';
import 'src/features/detail/detail_pengajuan_hr/detail_cuti_khusus/widget/detail_hr_cuti_khusus_controller.dart';
import 'src/features/detail/detail_pengajuan_hr/detail_perjalanan_dinas/widgets/detail_hr_perjalanan_dinas_controller.dart';
import 'src/features/detail/detail_pengajuan_hr/detail_view_hr/cuti_khusus_detail_hr/widgets/cuti_khusus_detail_hr_controller.dart';
import 'src/features/detail/detail_pengajuan_hr/detail_view_hr/perjalanan_dinas_detail_hr/widgets/perjalanan_dinas_detail_hr_controller.dart';
import 'src/features/detail/need_aprrove/detail_need_approve/detail_need_confirm_cuti_tahunan/widgets/detail_need_confirm_cuti_tahunan_controller.dart';
import 'src/features/detail/need_aprrove/detail_need_approve/detail_need_confirm_izin_sakit/widgets/detail_need_confirm_izin_sakit.dart';
import 'src/features/detail/need_aprrove/detail_need_approve/detail_need_confirm_perjalanan_dinas/widgets/detail_need_perjalanan_dinas_controller.dart';
import 'src/features/detail/need_aprrove/need_confirm_cuti_khusus/widgets/need_confirm_cuti_khusus_controller.dart';
import 'src/features/detail/need_aprrove/need_confirm_cuti_tahunan/widgets/need_confirm_cuti_tahunan_controller.dart';
import 'src/features/detail/need_aprrove/need_confirm_izin_sakit/widgets/need_confirm_izin_sakit_controller.dart';
import 'src/features/detail/need_aprrove/need_confirm_perjalanan_dinas/widgets/need_confirm_perjalanan_dinas_controller.dart';
import 'src/features/pengajuan/cuti_khusus/widgets/cuti_khusus_controller.dart';
import 'src/features/pengajuan/edit_pengajuan/edit_pengajuan_cuti_khusus/widget/cuti_khusus_edit_data_controller.dart';
import 'src/features/pengajuan/edit_pengajuan/edit_pengajuan_perjalanan_dinas/widget/perjalanan_dinas_edit_data_controller.dart';
import 'src/features/pengajuan/perjalanan_dinas/widgets/perjalanan_dinas_controller.dart';
import 'src/features/pengajuan_hr/cuti_khusus/widget/hr_cuti_khusus_controller.dart';
import 'src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_cuti_khusus/widgets/hr_cuti_khusus_edit_data_controller.dart';
import 'src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_cuti_khusus/widgets/hr_cuti_khusus_update_attachment_controller.dart';
import 'src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_perjalanan_dinas/widgets/hr_perjalanan_dinas_edit_attachment_controller.dart';
import 'src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_perjalanan_dinas/widgets/hr_perjalanan_dinas_edit_data.controller.dart';
import 'src/features/pengajuan_hr/perjalanan_dinas/widget/hr_perjalanan_dinas_list_controller.dart';

class DependencyInjection implements Bindings {
  @override
  Future<void> dependencies() async {
    Get.lazyPut(() => GetStorage(), fenix: true);
    Get.lazyPut(() => AuthStorageHelper(Get.find()), fenix: true);
    Get.lazyPut(() => AppInterceptor(Get.find()), fenix: true);
    Get.lazyPut(() => DioClients(), fenix: true);

    //appbar
    Get.lazyPut(() => AppBarController(Get.find()), fenix: true);
    Get.lazyPut(() => AppbarService(Get.find()), fenix: true);

    //login
    Get.lazyPut(() => LoginController(Get.find(), Get.find()), fenix: true);
    Get.lazyPut(() => LoginService(Get.find(), Get.find()), fenix: true);

    //izin 3 jam
    Get.lazyPut(() => Izin3JamListService(Get.find()), fenix: true);
    Get.lazyPut(() => Izin3JamListController(Get.find()), fenix: true);

    Get.lazyPut(() => PengajuanIzin3JamService(Get.find()), fenix: true);
    Get.lazyPut(() => PengajuanIzin3JamController(Get.find()), fenix: true);

    Get.lazyPut(() => DataIzin3JamService(Get.find()), fenix: true);
    Get.lazyPut(() => DataIzin3JamController(Get.find()), fenix: true);
    Get.lazyPut(() => DataIzin3JamDetailController(Get.find()), fenix: true);

    Get.lazyPut(() => ConfirmIzin3JamService(Get.find()), fenix: true);
    Get.lazyPut(() => ConfirmIzin3JamController(Get.find()), fenix: true);

    Get.lazyPut(() => DeleteIzin3JamService(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteIzin3JamController(Get.find()), fenix: true);

    Get.lazyPut(() => InputAttachmentIzin3JamService2(Get.find()), fenix: true);
    Get.lazyPut(() => InputAttachmentIzin3JamController(Get.find()),
        fenix: true);
    Get.lazyPut(
        () =>
            InputAttachmentConfirmedApprovedEditIzin3JamController(Get.find()),
        fenix: true);

    Get.lazyPut(() => CancelledIzin3JamService(Get.find()), fenix: true);
    Get.lazyPut(() => CancelPengajuanIzin3JamController(Get.find()),
        fenix: true);

    Get.lazyPut(() => EditIzin3JamService(Get.find()), fenix: true);
    Get.lazyPut(() => EditIzin3JamController(Get.find()), fenix: true);

    Get.lazyPut(() => GetAttachmentIzin3JamService2(Get.find()), fenix: true);
    Get.lazyPut(() => GetAttachmentIzin3JamDetailController(Get.find()),
        fenix: true);
    Get.lazyPut(() => GetAttachmentEditIzin3JamController(Get.find()),
        fenix: true);

    Get.lazyPut(() => DeleteAttachmentIzin3JamService2(Get.find()),
        fenix: true);
    Get.lazyPut(() => DeleteAttachmentEditIzin3JamController(Get.find()),
        fenix: true);

    Get.lazyPut(() => DownloadAttachmentIzin3JamService2(Get.find()),
        fenix: true);
    Get.lazyPut(() => DownloadAttachmentIzin3JamController(Get.find()),
        fenix: true);
    Get.lazyPut(() => ListLogIzin3JamController(Get.find()), fenix: true);

    //cuti khusus
    Get.lazyPut(() => PengajuanCutiKhususService(Get.find()), fenix: true);
    Get.lazyPut(() => CutiKhususController(Get.find()), fenix: true);
    Get.lazyPut(() => DetailEditCutiKhususController(Get.find()), fenix: true);
    Get.lazyPut(() => DetailCutiKhususController(Get.find()), fenix: true);
    Get.lazyPut(() => DetailDataCutiKhususController(Get.find()), fenix: true);

    //hr cuti khusus
    Get.lazyPut(() => HRCutiKhususService(Get.find()), fenix: true);
    Get.lazyPut(() => HrCutiKhususController(Get.find()), fenix: true);
    Get.lazyPut(() => DetailEditHrCutiKhususController(Get.find()),
        fenix: true);
    Get.lazyPut(() => DetailDataHrCutiKhususController(Get.find()),
        fenix: true);
    Get.lazyPut(() => DetailHrCutiKhususController(Get.find()), fenix: true);
    Get.lazyPut(() => EditAttachmentCutiKhususController(Get.find()),
        fenix: true);

    // Approver Cuti Khusus
    Get.lazyPut(() => CutiKhususApprovalService(Get.find()), fenix: true);
    Get.lazyPut(() => CutiKhususApprovalController(Get.find()), fenix: true);
    Get.lazyPut(() => NeedConfirmCutiKhususController(Get.find()), fenix: true);
    Get.lazyPut(() => DetailNeedConfirmCutiKhususController(Get.find()),
        fenix: true);
    Get.lazyPut(() => GetattachmentApprovalCutiKhususController(Get.find()),
        fenix: true);
    Get.lazyPut(() => ListLogCutiKhususController(Get.find()), fenix: true);

    //Perjalanan Dinas
    Get.lazyPut(() => PengajuanPerjalananDinasService(Get.find()), fenix: true);
    Get.lazyPut(() => PerjalananDinasController(Get.find()), fenix: true);
    Get.lazyPut(() => DetailEditPerjalananDinasController(Get.find()),
        fenix: true);
    Get.lazyPut(() => DetailPerjalananDinasController(Get.find()), fenix: true);
    Get.lazyPut(() => DetailDataPerjalananDinasController(Get.find()),
        fenix: true);

    //hr Perjalanan Dinas
    Get.lazyPut(() => HRPerjalananDinasService(Get.find()), fenix: true);
    Get.lazyPut(() => HrPerjalananDinasController(Get.find()), fenix: true);
    Get.lazyPut(() => DetailEditHrPerjalananDinasController(Get.find()),
        fenix: true);
    Get.lazyPut(() => DetailHrPerjalananDinasController(Get.find()),
        fenix: true);
    Get.lazyPut(() => DetailDataHrPerjalananDinasController(Get.find()),
        fenix: true);
    Get.lazyPut(() => EditAttachmentPerjalananDinasController(Get.find()),
        fenix: true);

    // Approver Perjalanan Dinas
    Get.lazyPut(() => PerjalananDinasApprovalService(Get.find()), fenix: true);
    Get.lazyPut(() => PerjalananDinasApprovalController(Get.find()),
        fenix: true);
    Get.lazyPut(() => NeedConfirmPerjalananDinasController(Get.find()),
        fenix: true);
    Get.lazyPut(() => DetailNeedConfirmPerjalananDinasController(Get.find()),
        fenix: true);
    Get.lazyPut(
        () => GetattachmentApprovalPerjalananDinasController(Get.find()),
        fenix: true);
    Get.lazyPut(() => ListLogPerjalananDinasController(Get.find()),
        fenix: true);

    //master company
    Get.lazyPut(() => MasterCompanyListController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterCompanyListService(Get.find()), fenix: true);

    Get.lazyPut(() => MasterCompanyDeleteController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterCompanyDeleteService(Get.find()), fenix: true);

    Get.lazyPut(() => MasterCompanyInputController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterCompanyInputService(Get.find()), fenix: true);

    Get.lazyPut(() => MasterCompanyEditController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterCompanyEditService(Get.find()), fenix: true);

    Get.lazyPut(() => MasterCompanyDetailController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterCompanyDetailService(Get.find()), fenix: true);

    //master approver
    Get.lazyPut(() => MasterApproverListController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterApproverListService(Get.find()), fenix: true);

    Get.lazyPut(() => MasterApproverDeleteController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterApproverDeleteService(Get.find()), fenix: true);

    Get.lazyPut(() => MasterApproverInputController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterApproverInputService(Get.find()), fenix: true);

    Get.lazyPut(() => MasterApproverEditController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterApproverEditService(Get.find()), fenix: true);

    Get.lazyPut(() => MasterApproverDetailController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterApproverDetailService(Get.find()), fenix: true);

    //master karyawan
    Get.lazyPut(() => MasterKaryawanListController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterKaryawanListService(Get.find()), fenix: true);

    Get.lazyPut(() => MasterKaryawanDeleteController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterKaryawanDeleteService(Get.find()), fenix: true);

    Get.lazyPut(() => MasterKaryawanInputController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterKaryawanInputService(Get.find()), fenix: true);

    Get.lazyPut(() => MasterKaryawanEditController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterKaryawanEditService(Get.find()), fenix: true);

    Get.lazyPut(() => MasterKaryawanDetailController(Get.find()), fenix: true);
    Get.lazyPut(() => MasterKaryawanDetailService(Get.find()), fenix: true);

    // Hr izin Sakit
    Get.lazyPut(() => HRIzinSakitListServicess(Get.find()), fenix: true);
    Get.lazyPut(() => HrIzinSakitListController(Get.find()), fenix: true);

    Get.lazyPut(() => HrInputIzinSakitController(Get.find()), fenix: true);
    Get.lazyPut(() => HrIzinSakitInputServices(Get.find()), fenix: true);

    Get.lazyPut(() => DeleteIzinSakitHrController(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteIzinSakitHrServices(Get.find()), fenix: true);

    Get.lazyPut(() => DetailDataIzinSakitHrServices(Get.find()), fenix: true);
    Get.lazyPut(() => DetailIzinSakitHrController(Get.find()), fenix: true);

    Get.lazyPut(() => ConfirmIzinSakitHrServices(Get.find()), fenix: true);
    Get.lazyPut(() => ConfirmIzinSakitHrController(Get.find()), fenix: true);

    Get.lazyPut(() => InputAttachmentIzinSakitHrServices(Get.find()),
        fenix: true);
    Get.lazyPut(() => InputAttachmentIzinSakitHrController(Get.find()),
        fenix: true);

    Get.lazyPut(() => CancelledIzinSakitHrServices(Get.find()), fenix: true);
    Get.lazyPut(() => CancelIzinSakitHrController(Get.find()), fenix: true);

    Get.lazyPut(() => GetAttachmentIzinSakitHrController(Get.find()),
        fenix: true);
    Get.lazyPut(() => GetAttachmentIzinSakitHrServices(Get.find()),
        fenix: true);

    Get.lazyPut(
        () =>
            InputAttachmentConfirmApproveEditIzinSakitHrController(Get.find()),
        fenix: true);
    Get.lazyPut(() => InputAttachmentIzinSakitServicess(Get.find()),
        fenix: true);

    Get.lazyPut(() => DeleteAttachmentIzinSakitHrServicess(Get.find()),
        fenix: true);
    Get.lazyPut(() => DeleteAtttchmentIzinSakitHrController(Get.find()),
        fenix: true);

    Get.lazyPut(() => DetailDataIzinSakitHrServices(Get.find()), fenix: true);
    Get.lazyPut(() => DataEditIzinSakitHrController(Get.find()), fenix: true);

    Get.lazyPut(() => EditizinSakitHrServicess(Get.find()), fenix: true);
    Get.lazyPut(() => EditIzinSakitHrController(Get.find()), fenix: true);

    // Approver izin sakit
    Get.lazyPut(() => IzinSakitApprovalService(Get.find()), fenix: true);
    Get.lazyPut(() => IzinSakitApprovalController(Get.find()), fenix: true);
    Get.lazyPut(() => NeedConfirmIzinSakitController(Get.find()), fenix: true);
    Get.lazyPut(() => DetailNeedConfirmIzinSakitController(Get.find()),
        fenix: true);
    Get.lazyPut(() => GetattachmentApprovalIzinSakitController(Get.find()),
        fenix: true);
    Get.lazyPut(() => ListLogIzinSakitController(Get.find()), fenix: true);

    //izin sakit
    Get.lazyPut(() => IzinSakitListServices(Get.find()), fenix: true);
    Get.lazyPut(() => IzinSakitListController(Get.find()), fenix: true);

    Get.lazyPut(() => IzinSakitInputServices(Get.find()), fenix: true);
    Get.lazyPut(() => InputIzinSakitController(Get.find()), fenix: true);

    Get.lazyPut(() => DetailDataIzinSakitServices(Get.find()), fenix: true);
    Get.lazyPut(() => DetailIzinSakitDataController(Get.find()), fenix: true);

    Get.lazyPut(() => DeleteIzinSakitServices(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteIzinSakitController(Get.find()), fenix: true);

    Get.lazyPut(() => EditizinSakitServicess(Get.find()), fenix: true);
    Get.lazyPut(() => EditIzinSakitController(Get.find()), fenix: true);

    Get.lazyPut(() => DetailIzinSakitController(Get.find()), fenix: true);
    Get.lazyPut(() => DetailDataIzinSakitServices(Get.find()), fenix: true);

    Get.lazyPut(() => GetAttachmentIzinSakitController(Get.find()),
        fenix: true);
    Get.lazyPut(() => GetAttachmentIzinSakitServicess(Get.find()), fenix: true);

    Get.lazyPut(
        () =>
            InputAttachmentConfirmedApprovedEditIzinSakitController(Get.find()),
        fenix: true);
    Get.lazyPut(() => InputAttachmentIzinSakitServicess(Get.find()),
        fenix: true);

    Get.lazyPut(() => DeleteAttachmentIzinSakitServicess(Get.find()),
        fenix: true);
    Get.lazyPut(() => DeleteAttachmentIzinSakitController(Get.find()),
        fenix: true);

    Get.lazyPut(() => ConfirmIzinSakitServices(Get.find()), fenix: true);
    Get.lazyPut(() => ConfirmIzinSakitController(Get.find()), fenix: true);

    Get.lazyPut(() => CancelledIzinSakitServices(Get.find()), fenix: true);
    Get.lazyPut(() => CancelIzinSakitController(Get.find()), fenix: true);

    Get.lazyPut(() => InputAttachmentIzinSakitServicess(Get.find()),
        fenix: true);
    Get.lazyPut(() => InputAttachmentIzinSakitController(Get.find()),
        fenix: true);

    Get.lazyPut(() => DownloadAttachmentIzinSakit(Get.find()), fenix: true);
    Get.lazyPut(() => DownloadIzinSakitController(Get.find()), fenix: true);

    // Approver cuti tahunan
    Get.lazyPut(() => CutiTahunanApprovalService(Get.find()), fenix: true);
    Get.lazyPut(() => CutiTahunanApprovalController(Get.find()), fenix: true);
    Get.lazyPut(() => NeedConfirmCutiTahunanController(Get.find()),
        fenix: true);
    Get.lazyPut(() => DetailNeedConfirmCutiTahunanController(Get.find()),
        fenix: true);
    Get.lazyPut(() => GetattachmentApprovalCutiTahunanController(Get.find()),
        fenix: true);
    Get.lazyPut(() => ListLogCutiTahunanController(Get.find()), fenix: true);

    //cuti tahunan
    Get.lazyPut(() => CutiTahunanListServices(Get.find()), fenix: true);
    Get.lazyPut(() => CutiTahunanListController(Get.find()), fenix: true);

    Get.lazyPut(() => SisaKuotaCutiTahunanServices(Get.find()), fenix: true);
    Get.lazyPut(() => SisaKuotaController(Get.find()), fenix: true);

    Get.lazyPut(() => InputCutiTahunanServices(Get.find()), fenix: true);
    Get.lazyPut(() => InputCutitahunanController(Get.find()), fenix: true);

    Get.lazyPut(() => DeleteCutiTahunanServices(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteCutiTahunanController(Get.find()), fenix: true);

    Get.lazyPut(() => ConfirmCutiTahunanServices(Get.find()), fenix: true);
    Get.lazyPut(() => ConfirmCutiTahunanController(Get.find()), fenix: true);

    Get.lazyPut(() => CancelledCutiTahunanServices(Get.find()), fenix: true);
    Get.lazyPut(() => CancelledCutiTahunanController(Get.find()), fenix: true);

    Get.lazyPut(() => InputAttachmentCutiTahunanServicess(Get.find()),
        fenix: true);
    Get.lazyPut(() => InputAttachmentCutiTahunanController(Get.find()),
        fenix: true);

    Get.lazyPut(() => DetailDataCutiTahunanServicess(Get.find()), fenix: true);
    Get.lazyPut(() => DetailCutiTahunanDataController(Get.find()), fenix: true);

    Get.lazyPut(() => DeleteAttachmentCutiTahunanServicess(Get.find()),
        fenix: true);
    Get.lazyPut(() => DeleteAttachmentCutiTahunanController(Get.find()),
        fenix: true);

    Get.lazyPut(() => EditCutiTahunanServicess(Get.find()), fenix: true);
    Get.lazyPut(() => EditCutiTahunanController(Get.find()), fenix: true);

    Get.lazyPut(() => DetailCutiTahunanController(Get.find()), fenix: true);
    Get.lazyPut(() => DetailDataCutiTahunanServices(Get.find()), fenix: true);

    Get.lazyPut(() => GetAttachmentCutiTahunanController(Get.find()),
        fenix: true);
    Get.lazyPut(() => GetAttachmentCutiTahunanServicess(Get.find()),
        fenix: true);

    Get.lazyPut(
        () =>
            InputAttachmentConfirmApproveEditCutiTahunanController(Get.find()),
        fenix: true);
    Get.lazyPut(() => InputAttachmentCutiTahunanServicess(Get.find()),
        fenix: true);

    Get.lazyPut(() => DownloadAttachmentCutiTahunanServices(Get.find()),
        fenix: true);
    Get.lazyPut(() => DownloadCutiTahunanController(Get.find()), fenix: true);

    //hr cuti tahunan
    Get.lazyPut(() => CutiTahunanHrListServices(Get.find()), fenix: true);
    Get.lazyPut(() => CutiTahunanHrListController(Get.find()), fenix: true);

    Get.lazyPut(() => HrInputCutiTahunanController(Get.find()), fenix: true);
    Get.lazyPut(() => HrCutiTahunanInputServices(Get.find()), fenix: true);

    Get.lazyPut(() => DeleteCutiTahunanHrController(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteCutiTahunanHrService(Get.find()), fenix: true);

    Get.lazyPut(() => DetailDataCutiTahunanHrServices(Get.find()), fenix: true);
    Get.lazyPut(() => DetailCutiTahunanHrController(Get.find()), fenix: true);

    Get.lazyPut(() => ConfirmCutiTahunanHrService(Get.find()), fenix: true);
    Get.lazyPut(() => ConfirmCutiTahunanHrController(Get.find()), fenix: true);

    Get.lazyPut(() => CancelCutiTahunanHrService(Get.find()), fenix: true);
    Get.lazyPut(() => CancelCutiTahunanHrController(Get.find()), fenix: true);

    Get.lazyPut(() => InputAttachmentCutiTahunanHrServices(Get.find()),
        fenix: true);
    Get.lazyPut(() => InputAttachmentCutiTahunanHrController(Get.find()),
        fenix: true);

    Get.lazyPut(() => DetailViewCutiTahunanHrController(Get.find()),
        fenix: true);

    Get.lazyPut(() => DataEditCutiTahunanHrController(Get.find()), fenix: true);
    Get.lazyPut(() => DetailDataCutiTahunanHrServices(Get.find()), fenix: true);

    Get.lazyPut(() => DeleteAttachmentCutiTahunanHrController(Get.find()),
        fenix: true);
    Get.lazyPut(() => DeleteAttachmentCutiTahunanHrServicess(Get.find()),
        fenix: true);

    Get.lazyPut(() => EditCutiTahunanHrController(Get.find()), fenix: true);
    Get.lazyPut(() => EditCutiTahunanHrServices(Get.find()), fenix: true);

    Get.lazyPut(() => GetAttachmentCutiTahunanHrController(Get.find()),
        fenix: true);
    Get.lazyPut(() => GetAttachmentCutiTahunanHrService(Get.find()),
        fenix: true);

    Get.lazyPut(
        () => InputattachmentConfirmApproveEditCutiTahunanHrController(
            Get.find()),
        fenix: true);
    Get.lazyPut(() => InputAttachmentCutiTahunanHrServices(Get.find()),
        fenix: true);

    //hr cuti tahunan
    /* -------------------------------------------------------------------------- */
    /*                               CHANGE PASSWORD                              */
    /* -------------------------------------------------------------------------- */
    Get.lazyPut(() => ChangePasswordService(Get.find()), fenix: true);
    Get.lazyPut(() => ChangePasswordController(Get.find()), fenix: true);

    // Approver Izin 3 Jam
    Get.lazyPut(() => HrIzin3JamListService2(Get.find()), fenix: true);
    Get.lazyPut(() => ListIzin3JamApprovalController(Get.find()), fenix: true);
    Get.lazyPut(() => NeedConfirmIzin3JamController(Get.find()), fenix: true);

    Get.lazyPut(() => HrRefusedIzin3JamService(Get.find()), fenix: true);
    Get.lazyPut(() => RefusedIzin3JamController(Get.find()), fenix: true);

    Get.lazyPut(() => ApprovedIzin3JamController(Get.find()), fenix: true);
    Get.lazyPut(() => HrApprovedIzin3JamService(Get.find()), fenix: true);

    Get.lazyPut(() => DetailNeedConfirm3JamController(Get.find()), fenix: true);
    Get.lazyPut(() => HrDataIzin3JamService(Get.find()), fenix: true);

    Get.lazyPut(() => HrGetAttachmentEditIzin3JamController(Get.find()),
        fenix: true);
    Get.lazyPut(() => HrGetAttachmentIzin3JamService(Get.find()), fenix: true);
    //Dashboard Hr
    Get.lazyPut(() => DashboardHrService(Get.find()), fenix: true);
    Get.lazyPut(() => DashboardHrController(Get.find(), Get.find()),
        fenix: true);

    //Dashboard Karyawan
    Get.lazyPut(() => DashboardSayaService(Get.find()), fenix: true);
    Get.lazyPut(() => DashboardSayaController(Get.find(), Get.find()),
        fenix: true);

    //List Perusahaan
    Get.lazyPut(() => GetPerusahaanLaporanService(Get.find()), fenix: true);
    Get.lazyPut(() => PerusahaanController(Get.find()), fenix: true);

    // Laporan Cuti Tahunan
    Get.lazyPut(() => LaporanCutiTahunanController(Get.find()), fenix: true);
    Get.lazyPut(() => GetLaporanCutiTahunanService(Get.find()), fenix: true);

    Get.lazyPut(() => ExportLaporanCutiTahunanController(Get.find()),
        fenix: true);
    Get.lazyPut(() => ExportLaporanCutiTahunanService(Get.find()), fenix: true);

    // Input Izin 3 Jam by HR
    Get.lazyPut(() => ListIzin3JamHrController(Get.find()), fenix: true);
    Get.lazyPut(() => Izin3JamListHrService(Get.find()), fenix: true);

    Get.lazyPut(() => HrPengajuanIzin3JamController(Get.find()), fenix: true);
    Get.lazyPut(() => HrPengajuanIzin3JamService(Get.find()), fenix: true);

    Get.lazyPut(() => HrListKaryawanController(Get.find()), fenix: true);
    Get.lazyPut(() => HrListKaryawanService(Get.find()), fenix: true);

    Get.lazyPut(() => HrDataIzin3JamController(Get.find()), fenix: true);
    Get.lazyPut(() => HrDataDetailIzin3JamService(Get.find()), fenix: true);

    Get.lazyPut(() => HrDeleteIzin3JamController(Get.find()), fenix: true);
    Get.lazyPut(() => HrDeleteIzin3JamService(Get.find()), fenix: true);

    Get.lazyPut(() => HrConfirmIzin3JamController(Get.find()), fenix: true);
    Get.lazyPut(() => HrConfirmIzin3JamService(Get.find()), fenix: true);

    Get.lazyPut(() => HrCancelledIzin3JamService(Get.find()), fenix: true);
    Get.lazyPut(() => HrCancelPengajuanIzin3JamController(Get.find()),
        fenix: true);

    Get.lazyPut(() => HrDownloadAttachmentIzin3JamController(Get.find()),
        fenix: true);
    Get.lazyPut(() => HrGetAttachmentIzin3JamDetailController(Get.find()),
        fenix: true);
    Get.lazyPut(() => HrDataDetailIzin3JamController(Get.find()), fenix: true);

    Get.lazyPut(() => HrInputAttachmentIzin3JamController(Get.find()),
        fenix: true);

    Get.lazyPut(() => HrDeleteAttachmentEditIzin3JamController(Get.find()),
        fenix: true);
    Get.lazyPut(() => HrDeleteAttachmentIzin3JamService(Get.find()),
        fenix: true);
    Get.lazyPut(() => HrEditIzin3JamController(Get.find()), fenix: true);
    Get.lazyPut(() => HrEditIzin3JamService(Get.find()), fenix: true);
    Get.lazyPut(
        () => HrInputAttachmentConfirmedApprovedEditIzin3JamController(
            Get.find()),
        fenix: true);

    //Master Jumlah Cuti Tahunan
    Get.lazyPut(() => MasterJumlahCutiTahunanListController(Get.find()),
        fenix: true);
    Get.lazyPut(() => MasterJumlahCutiTahunanListServices(Get.find()),
        fenix: true);

    Get.lazyPut(() => MasterJumlahCutiTahunanGenerateServices(Get.find()),
        fenix: true);
    Get.lazyPut(() => MasterJumlahCutiTahunanGenerateController(Get.find()),
        fenix: true);

    // Laporan izin sakit
    Get.lazyPut(() => ExportLaporanIzinSakitController(Get.find()),
        fenix: true);
    Get.lazyPut(() => ExportLaporanIzinSakitService(Get.find()), fenix: true);
    Get.lazyPut(() => LaporanIzinSakitController(Get.find()), fenix: true);
    Get.lazyPut(() => GetLaporanIzinSakitService(Get.find()), fenix: true);

// Laporan izin 3jam
    Get.lazyPut(() => ExportLaporanIzin3JamController(Get.find()), fenix: true);
    Get.lazyPut(() => ExportLaporanIzin3JamService(Get.find()), fenix: true);
    Get.lazyPut(() => LaporanIzin3JamController(Get.find()), fenix: true);
    Get.lazyPut(() => GetLaporanIzin3JamService(Get.find()), fenix: true);

//Dashboard karyawan
    Get.lazyPut(() => DashboardKaryawanService(Get.find()), fenix: true);
    Get.lazyPut(() => DashboardKaryawanController(Get.find(), Get.find()),
        fenix: true);

    // Master Jumlah Cuti Tahunan
    Get.lazyPut(() => MasterJumlahCutiTahunanEditServices(Get.find()),
        fenix: true);
    Get.lazyPut(() => MasterJumlahCutiTahunanDetailDataServices(Get.find()),
        fenix: true);
    Get.lazyPut(() => DetailDataMasterCutiTahunan(Get.find()), fenix: true);
    Get.lazyPut(() => MasterJumlahCutiTahunanEditController(Get.find()),
        fenix: true);

    // Laporan Cuti Khusus
    Get.lazyPut(() => ExportLaporanCutiKhususController(Get.find()),
        fenix: true);
    Get.lazyPut(() => ExportLaporanCutiKhususService(Get.find()), fenix: true);
    Get.lazyPut(() => LaporanCutiKhususController(Get.find()), fenix: true);
    Get.lazyPut(() => GetLaporanCutiKhususService(Get.find()), fenix: true);

    //Laporan Perjalanan Dinas
    Get.lazyPut(() => ExportLaporanPerjalananDinasController(Get.find()),
        fenix: true);
    Get.lazyPut(() => ExportLaporanPerjalananDinasService(Get.find()),
        fenix: true);
    Get.lazyPut(() => LaporanPerjalananDinasController(Get.find()),
        fenix: true);
    Get.lazyPut(() => GetLaporanPerjalananDinasService(Get.find()),
        fenix: true);

    //lupa password
    Get.lazyPut(() => LupaPasswordController(Get.find()), fenix: true);
    Get.lazyPut(() => LupaPasswordService(Get.find()), fenix: true);
  }
}
