import 'package:get/get.dart';

import '../../../../../core/model/approval/cuti_khusus/cuti_khusus_list_model.dart';
import '../../../../../core/services/approval/cuti_khusus_service/cuti_khusus_approval_service.dart';

class ListLogCutiKhususController extends GetxController with StateMixin<List<ApprovalCutiKhususListModel>> {
  CutiKhususApprovalService service;
  ListLogCutiKhususController(this.service);

  RxBool isFetchData = true.obs;

  RxList<ApprovalCutiKhususListModel> dataCutiKhusus = <ApprovalCutiKhususListModel>[].obs;

  RxInt pageSize = 10.obs;
  RxString filterStatus2 = 'Refused,Cancelled,Approved'.obs;

  Future<List<ApprovalCutiKhususListModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'Refused,Cancelled,Approved',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    return await service.fetchCutiKhusus(
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
      change(dataCutiKhusus.value = value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}
