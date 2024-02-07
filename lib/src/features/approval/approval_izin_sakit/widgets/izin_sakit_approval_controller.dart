import 'package:get/get.dart';

import '../../../../core/model/approval/izin_sakit/izin_sakit_list_model.dart';
import '../../../../core/services/approval/izin_sakit_services/izin_sakit_approval_service.dart';

class IzinSakitApprovalController extends GetxController with StateMixin<List<ApprovalIzinSakitListModel>> {
  IzinSakitApprovalService service;
  IzinSakitApprovalController(this.service);

  RxBool isFetchData = true.obs;

  RxList<ApprovalIzinSakitListModel> dataIzinSakit = <ApprovalIzinSakitListModel>[].obs;

  Future<List<ApprovalIzinSakitListModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    return await service.fetchIzinSakit(
      filterStatus: filterStatus,
      page: page,
      size: size,
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
