import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginFailure extends Failure {
  const LoginFailure(super.message);
}

class ChangePasswordFailure extends Failure {
  const ChangePasswordFailure(super.message);
}

//  IZIN 3 JAM
class ConfirmIzin3JamFailure extends Failure {
  const ConfirmIzin3JamFailure(super.message);
}

class DeleteIzin3JamFailure extends Failure {
  const DeleteIzin3JamFailure(super.message);
}

class CancelIzin3JamFailure extends Failure {
  const CancelIzin3JamFailure(super.message);
}

class PengajuanIzin3JamFailure extends Failure {
  const PengajuanIzin3JamFailure(super.message);
}

class InputAttachmentEditIzin3JamFailure extends Failure {
  const InputAttachmentEditIzin3JamFailure(super.message);
}

class EditIzin3JamFailure extends Failure {
  const EditIzin3JamFailure(super.message);
}

class RefusedIzin3JamFailure extends Failure {
  const RefusedIzin3JamFailure(super.message);
}

class ApprovedIzin3JamFailure extends Failure {
  const ApprovedIzin3JamFailure(super.message);
}
// IZIN 3 JAM

//  CutiKhusus
class CutiKhususConfirmFailure extends Failure {
  const CutiKhususConfirmFailure(super.message);
}

class CutiKhususDeleteFailure extends Failure {
  const CutiKhususDeleteFailure(super.message);
}

class CutiKhususCancelFailure extends Failure {
  const CutiKhususCancelFailure(super.message);
}

class CutiKhususInputFailure extends Failure {
  const CutiKhususInputFailure(super.message);
}

class CutiKhususInputAttachmentEditFailure extends Failure {
  const CutiKhususInputAttachmentEditFailure(super.message);
}

class RefusedCutiKhususFailure extends Failure {
  const RefusedCutiKhususFailure(super.message);
}

class ApprovedCutiKhususFailure extends Failure {
  const ApprovedCutiKhususFailure(super.message);
}
// CutiKhusus

// HrCutiKhusus
class HrCutiKhususInputFailure extends Failure {
  const HrCutiKhususInputFailure(super.message);
}

class HrCutiKhususConfirmFailure extends Failure {
  const HrCutiKhususConfirmFailure(super.message);
}

class HrCutiKhususDeleteFailure extends Failure {
  const HrCutiKhususDeleteFailure(super.message);
}

class HrCutiKhususCancelFailure extends Failure {
  const HrCutiKhususCancelFailure(super.message);
}
// HrCutiKhusus

//  PerjalananDinas
class PerjalananDinasConfirmFailure extends Failure {
  const PerjalananDinasConfirmFailure(super.message);
}

class PerjalananDinasDeleteFailure extends Failure {
  const PerjalananDinasDeleteFailure(super.message);
}

class PerjalananDinasCancelFailure extends Failure {
  const PerjalananDinasCancelFailure(super.message);
}

class PerjalananDinasInputFailure extends Failure {
  const PerjalananDinasInputFailure(super.message);
}

class PerjalananDinasInputAttachmentEditFailure extends Failure {
  const PerjalananDinasInputAttachmentEditFailure(super.message);
}

class RefusedPerjalananDinasFailure extends Failure {
  const RefusedPerjalananDinasFailure(super.message);
}

class ApprovedPerjalananDinasFailure extends Failure {
  const ApprovedPerjalananDinasFailure(super.message);
}
// PerjalananDinas

// HrPerjalananDinas
class HrPerjalananDinasInputFailure extends Failure {
  const HrPerjalananDinasInputFailure(super.message);
}

class HrPerjalananDinasConfirmFailure extends Failure {
  const HrPerjalananDinasConfirmFailure(super.message);
}

class HrPerjalananDinasDeleteFailure extends Failure {
  const HrPerjalananDinasDeleteFailure(super.message);
}

class HrPerjalananDinasCancelFailure extends Failure {
  const HrPerjalananDinasCancelFailure(super.message);
}
// HrPerjalananDinas

//Izin Sakit
class ConfirmIzinSakitFailure extends Failure {
  const ConfirmIzinSakitFailure(super.message);
}

class DeleteIzinSakitFailure extends Failure {
  const DeleteIzinSakitFailure(super.message);
}

class PengajuanIzinSakitFailure extends Failure {
  const PengajuanIzinSakitFailure(super.message);
}

class CancelledIzinSakitFailure extends Failure {
  const CancelledIzinSakitFailure(super.message);
}

class InputAttachmentizinSakitFailure extends Failure {
  const InputAttachmentizinSakitFailure(super.message);
}

class EditIzinSakitFailure extends Failure {
  const EditIzinSakitFailure(super.message);
}

class RefusedIzinSakitFailure extends Failure {
  const RefusedIzinSakitFailure(super.message);
}

class ApprovedIzinSakitFailure extends Failure {
  const ApprovedIzinSakitFailure(super.message);
}
//Izin Sakit

//Hr Izin Sakit
class PengajuanHRIzinSakitFailure extends Failure {
  const PengajuanHRIzinSakitFailure(super.message);
}

class InputAttachmentizinSakitHrFailure extends Failure {
  const InputAttachmentizinSakitHrFailure(super.message);
}

class DeleteIzinSakitHrFailure extends Failure {
  const DeleteIzinSakitHrFailure(super.message);
}

class ConfirmIzinSakitHrFailure extends Failure {
  const ConfirmIzinSakitHrFailure(super.message);
}

class CancelledIzinSakitHrFailure extends Failure {
  const CancelledIzinSakitHrFailure(super.message);
}

class EditIzinSakitHrFailure extends Failure {
  const EditIzinSakitHrFailure(super.message);
}

//Hr Izin Sakit

//Cuti tahunan
class PengajuanCutiTahunanFailure extends Failure {
  const PengajuanCutiTahunanFailure(super.message);
}

class CancelledCutiTahunanFailure extends Failure {
  const CancelledCutiTahunanFailure(super.message);
}

class ConfirmCutiTahunanFailure extends Failure {
  const ConfirmCutiTahunanFailure(super.message);
}

class DeleteCutiTahunanFailure extends Failure {
  const DeleteCutiTahunanFailure(super.message);
}

class InputAttachmentCutiTahunanFailure extends Failure {
  const InputAttachmentCutiTahunanFailure(super.message);
}

class EditCutiTahunanFailure extends Failure {
  const EditCutiTahunanFailure(super.message);
}

class RefusedCutiTahunanFailure extends Failure {
  const RefusedCutiTahunanFailure(super.message);
}

class ApprovedCutiTahunanFailure extends Failure {
  const ApprovedCutiTahunanFailure(super.message);
}
//Cuti tahunan

// hr cuti tahunan

class PengajuanHRCutiTahunanFailure extends Failure {
  const PengajuanHRCutiTahunanFailure(super.message);
}

class DeleteCutiTahunanHrFailure extends Failure {
  const DeleteCutiTahunanHrFailure(super.message);
}

class ConfirmCutiTahunanHrFailure extends Failure {
  const ConfirmCutiTahunanHrFailure(super.message);
}

class CancelledCutiTahunanHrFailure extends Failure {
  const CancelledCutiTahunanHrFailure(super.message);
}
class EditCutiTahunanHrFailure extends Failure {
  const EditCutiTahunanHrFailure(super.message);
}
class DeleteattachmentCutiTahunanHrFailure extends Failure {
  const DeleteattachmentCutiTahunanHrFailure(super.message);
}

// hr cuti tahunan

// Master Company
class MasterCompanyDeleteFailure extends Failure {
  const MasterCompanyDeleteFailure(super.message);
}

class MasterCompanyInputFailure extends Failure {
  const MasterCompanyInputFailure(super.message);
}

// Master Company

// Lupa PAssword
class LupaPasswordFailure extends Failure {
  const LupaPasswordFailure(super.message);
}
