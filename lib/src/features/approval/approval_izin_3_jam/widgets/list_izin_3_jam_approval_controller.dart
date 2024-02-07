import 'package:get/get.dart';
import 'package:project/src/core/model/approval/izin_3_jam/list_approval_izin_3_jam_model.dart';
import 'package:project/src/core/services/approval/izin_3_jam_service/hr_get_list_izin_3_jam_service.dart';

class ListIzin3JamApprovalController extends GetxController
    with StateMixin<List<ListApprovalIzin3JamModel>> {
  HrIzin3JamListService2 service;
  ListIzin3JamApprovalController(this.service);

  RxBool isFetchData = true.obs;

  RxInt pageNum = 1.obs;
  RxList<ListApprovalIzin3JamModel> dataIzin3Jam =
      <ListApprovalIzin3JamModel>[].obs;

  RxInt pageSize = 10.obs;
  RxString filterStatus2 = 'All'.obs;

  Future<List<ListApprovalIzin3JamModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    return await service.fetchIzin3Jam(
      filterStatus: filterStatus2.value,
      page: pageNum.value,
      size: pageSize.value,
      tanggalAkhir: tanggalAkhir,
      tanggalAwal: tanggalAwal,
    );
  }

  @override
  void onInit() {
    super.onInit();
    execute().then((value) {
      change(dataIzin3Jam.value = value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}
