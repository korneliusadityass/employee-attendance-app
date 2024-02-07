import 'package:get/get.dart';

import '../../../../core/model/approval/cuti_khusus/cuti_khusus_list_model.dart';
import '../../../../core/services/approval/cuti_khusus_service/cuti_khusus_approval_service.dart';

class CutiKhususApprovalController extends GetxController
    with StateMixin<List<ApprovalCutiKhususListModel>> {
  CutiKhususApprovalService service;
  CutiKhususApprovalController(this.service);

  RxBool isFetchData = true.obs;

  RxList<ApprovalCutiKhususListModel> dataCutiKhusus =
      <ApprovalCutiKhususListModel>[].obs;

  Future<List<ApprovalCutiKhususListModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    return await service.fetchCutiKhusus(
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
      change(dataCutiKhusus.value = value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}
