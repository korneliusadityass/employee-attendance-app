import 'package:get/get.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverlist_service.dart';

import '../../../../model/master/approver/masterapproverlist_model.dart';

class MasterApproverListController extends GetxController
    with StateMixin<List<MasterApproverListModel>> {
  MasterApproverListService masterapproverlistService;
  MasterApproverListController(this.masterapproverlistService);

  RxBool isFetchData = true.obs;

  RxList<MasterApproverListModel> dataApprover =
      <MasterApproverListModel>[].obs;

  Future<List<MasterApproverListModel>> execute({
    int page = 1,
    int size = 10,
    int id = 0,
    String? filterNama,
  }) async {
    final result = await masterapproverlistService.fetchApproverHRList(
      page: page,
      size: size,
      filterNama: filterNama,
      id: id,
    );

    dataApprover.value = result;
    isFetchData.value = false;
    return result;
  }

  @override
  void onInit() {
    super.onInit();
    execute();
    // .then((value) {
    //   change(dataApprover.value = value, status: RxStatus.success());
    // }).catchError((e) {
    //   change(null, status: RxStatus.error(e.toString()));
    // }).whenComplete(() => isFetchData.value = false);
  }
}
