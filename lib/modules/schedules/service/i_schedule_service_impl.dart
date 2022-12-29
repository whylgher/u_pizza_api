// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/entities/supplier_service.dart';
import 'package:cuidapet_api/modules/schedules/view_models/schedule_save_input_model.dart';
import 'package:injectable/injectable.dart';

import './i_schedule_service.dart';
import '../../../entities/schedule.dart';
import '../../../entities/schedule_service.dart';
import '../../../entities/supplier.dart';
import '../data/i_schedule_repository.dart';

@LazySingleton(as: IScheduleService)
class IScheduleServiceImpl implements IScheduleService {
  IScheduleRepository repository;

  IScheduleServiceImpl({
    required this.repository,
  });

  @override
  Future<void> scheduleService(ScheduleSaveInputModel model) async {
    final schedule = Schedule(
      scheduleDate: model.scheduleDate,
      name: model.name,
      petName: model.petName,
      supplier: Supplier(id: model.supplierId),
      status: 'P',
      userId: model.userId,
      services: model.services
          .map((e) => ScheduleService(
                service: SupplierService(id: e),
              ))
          .toList(),
    );

    await repository.save(schedule);
  }

  @override
  Future<void> changeStatus(String status, int scheduleId) =>
      repository.changeStatus(status, scheduleId);

  @override
  Future<List<Schedule>> findAllScheduleByUser(int userId) =>
      repository.findAllSchedulesByUser(userId);

  @override
  Future<List<Schedule>> findAllScheduleByUserSupplier(int userId) =>
      repository.findAllSchedulesBySupplier(userId);
}
