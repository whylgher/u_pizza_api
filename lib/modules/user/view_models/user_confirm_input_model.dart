import '../../../application/helpers/request_mapping.dart';

class UserConfirmInputModel extends RequestMapping {
  int userId;
  String acccessToken;
  late String iosDeviceToken;
  late String androidDeviceToken;

  UserConfirmInputModel(
      {required this.userId, required this.acccessToken, required String data})
      : super(data);

  @override
  void map() {
    iosDeviceToken = data['ios_token'] ?? '';
    androidDeviceToken = data['android_token'] ?? '';
  }
}
