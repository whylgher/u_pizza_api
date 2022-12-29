import '../../../dtos/supplier_near_by_me_dto.dart';
import '../../../entities/supplier.dart';
import '../../../entities/supplier_service.dart';
import '../view_models/create_supplier_user_view_model.dart';
import '../view_models/supplier_update_input_model.dart';

abstract class ISupplierService {
  Future<List<SupplierNearByMeDto>> findNearMeBy(double lat, double lng);

  Future<Supplier?> findById(int id);

  Future<List<SupplierService>> findServicesSupplier(int supplierId);

  Future<bool> checkUserEmailExists(String email);

  Future<void> createUserSupplier(CreateSupplierUserViewModel model);

  Future<Supplier> update(SupplierUpdateInputModel model);
}
