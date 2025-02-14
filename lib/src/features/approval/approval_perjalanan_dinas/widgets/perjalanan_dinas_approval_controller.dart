import 'package:get/get.dart';

import '../../../../core/model/approval/perjalanan_dinas/perjalanan_dinas_list_model.dart';
import '../../../../core/services/approval/perjalanan_dinas_service/perjalanan_dinas_approval_service.dart';

class PerjalananDinasApprovalController extends GetxController with StateMixin<List<ApprovalPerjalananDinasListModel>> {
  PerjalananDinasApprovalService service;
  PerjalananDinasApprovalController(this.service);

  RxBool isFetchData = true.obs;

  RxList<ApprovalPerjalananDinasListModel> dataPerjalananDinas = <ApprovalPerjalananDinasListModel>[].obs;

  Future<List<ApprovalPerjalananDinasListModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    return await service.fetchPerjalananDinas(
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
      change(dataPerjalananDinas.value = value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}
