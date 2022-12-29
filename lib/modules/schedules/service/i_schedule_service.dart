import '../../../entities/schedule.dart';
import '../view_models/schedule_save_input_model.dart';

abstract class IScheduleService {
  Future<void> scheduleService(ScheduleSaveInputModel model);
  Future<void> changeStatus(String status, int scheduleId);

  Future<List<Schedule>> findAllScheduleByUser(int userId);
  Future<List<Schedule>> findAllScheduleByUserSupplier(int userId);
}
