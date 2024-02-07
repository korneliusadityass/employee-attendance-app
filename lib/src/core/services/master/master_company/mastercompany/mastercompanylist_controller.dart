import 'package:get/get.dart';

import '../../../../model/master/company/mastercompanylist_model.dart';
import 'mastercompanylist_service.dart';

class MasterCompanyListController extends GetxController
    with StateMixin<List<MasterCompanyListModel>> {
  MasterCompanyListService mastercompanylistService;
  MasterCompanyListController(this.mastercompanylistService);

  RxBool isFetchData = true.obs;

  RxList<MasterCompanyListModel> dataPerusahaan =
      <MasterCompanyListModel>[].obs;

  Future<List<MasterCompanyListModel>> execute({
    int page = 1,
    int size = 10,
    String? filterNama,
    String order = 'asc',
  }) async {
    return await mastercompanylistService.fetchListPerusahaanModel(
        page: page, size: size, filterNama: filterNama, order: order);
  }

   @override
    void onInit() {
    super.onInit();
    execute().then((value) {
      change(dataPerusahaan.value = value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}
