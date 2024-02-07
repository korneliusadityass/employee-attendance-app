import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverinput_service.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverlist_controller.dart';

import '../../../../colors/color.dart';
import '../../../../routes/routes.dart';

class MasterApproverInputController extends GetxController {
  MasterApproverInputService service;
  MasterApproverInputController(this.service);

  RxInt id = 0.obs;

  Future masterApproverInput(
    int approverid,
    String karyawanid,
  ) async {
    await service.masterApproverInput(approverid, karyawanid);
    Get.offNamed(Routes.masterApprover);
    Get.find<MasterApproverListController>().execute();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: 278,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 31,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  color: kDarkGreenColor,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Icon(
                Icons.check_circle,
                color: kGreenColor,
                size: 80,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Sukses',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: kBlackColor,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: kDarkGreenColor,
                  fixedSize: const Size(120, 45),
                ),
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: const Text(
                  'Oke',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: kWhiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
