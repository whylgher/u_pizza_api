import '../../../dtos/supplier_near_by_me_dto.dart';
import '../../../entities/supplier.dart';
import '../../../entities/supplier_service.dart';

abstract class ISupplierRepository {
  Future<List<SupplierNearByMeDto>> findNearByPosition(
      double lat, double lng, int distance);

  Future<Supplier> findById(int id);

  Future<List<SupplierService>> findServicesBySupplierId(int supplierId);

  Future<bool> checkUserEmailExists(String email);

  Future<int> saveSupplier(Supplier supplier);

  Future<Supplier> update(Supplier supplier);
}
