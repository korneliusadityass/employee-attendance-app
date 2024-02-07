import 'package:get/get.dart';

import '../../../../../core/model/approval/cuti_khusus/cuti_khusus_list_model.dart';
import '../../../../../core/model/approval/cuti_tahunan/cuti_tahunan_list_model.dart';
import '../../../../../core/model/approval/izin_sakit/izin_sakit_list_model.dart';
import '../../../../../core/services/approval/cuti_khusus_service/cuti_khusus_approval_service.dart';
import '../../../../../core/services/approval/cuti_tahunan_services/cuti_tahunan_approval_service.dart';
import '../../../../../core/services/approval/izin_sakit_services/izin_sakit_approval_service.dart';

class ListLogIzinSakitController extends GetxController with StateMixin<List<ApprovalIzinSakitListModel>> {
  IzinSakitApprovalService service;
  ListLogIzinSakitController(this.service);

  RxBool isFetchData = true.obs;

  RxList<ApprovalIzinSakitListModel> dataIzinSakit = <ApprovalIzinSakitListModel>[].obs;

  RxInt pageSize = 10.obs;
  RxString filterStatus2 = 'Refused,Cancelled,Approved'.obs;

  Future<List<ApprovalIzinSakitListModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'Refused,Cancelled,Approved',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    return await service.fetchIzinSakit(
      filterStatus: filterStatus2.value,
      page: page,
      size: pageSize.value,
      filterNama: filterNama,
      tanggalAkhir: tanggalAkhir,
      tanggalAwal: tanggalAwal,
    );
  }

  @override
  void onInit() {
    super.onInit();
    execute().then((value) {
      change(dataIzinSakit.value = value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}
