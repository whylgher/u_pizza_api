import '../../../entities/user.dart';
import '../view_models/platform.dart';

abstract class IUserRepository {
  Future<User> createUser(User user);
  Future<User> loginWithEmailPassword(
      String email, String password, bool supplier);
  Future<User> loginByEmailSocialKey(
      String email, String socialKey, String socialType);
  Future<void> updateUserDeviceTokenAndRefreshToken(User user);
  Future<void> updateRefreshToken(User user);
  Future<User> findById(int id);
  Future<void> updateUrlAvatar(int id, String urlAvatar);
  Future<void> updateDeviceToken(int id, String token, Platform platForm);
}
