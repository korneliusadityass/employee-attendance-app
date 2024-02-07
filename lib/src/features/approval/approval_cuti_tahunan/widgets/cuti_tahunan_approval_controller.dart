import 'package:get/get.dart';

import '../../../../core/model/approval/cuti_tahunan/cuti_tahunan_list_model.dart';
import '../../../../core/services/approval/cuti_tahunan_services/cuti_tahunan_approval_service.dart';

class CutiTahunanApprovalController extends GetxController
    with StateMixin<List<ApprovalCutiTahunanListModel>> {
  CutiTahunanApprovalService service;
  CutiTahunanApprovalController(this.service);

  RxBool isFetchData = true.obs;

  RxList<ApprovalCutiTahunanListModel> dataCutiTahunan =
      <ApprovalCutiTahunanListModel>[].obs;

  Future<List<ApprovalCutiTahunanListModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    return await service.fetchCutiTahunan(
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
      change(dataCutiTahunan.value = value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}
