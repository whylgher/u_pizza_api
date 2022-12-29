import '../../../application/helpers/request_mapping.dart';
import 'platform.dart';

class UserUpdateDeviceInputModel extends RequestMapping {
  int userId;
  late String token;
  late Platform platform;

  UserUpdateDeviceInputModel({
    required this.userId,
    required String dataRequest,
  }) : super(dataRequest);

  @override
  void map() {
    String d = data['platform'];

    token = data['token'];

    platform = (d.toLowerCase() == 'ios' ? Platform.ios : Platform.android);
  }
}
