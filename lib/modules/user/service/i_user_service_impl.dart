import 'package:cuidapet_api/modules/user/view_models/user_update_device_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';

import './i_user_service.dart';
import '../../../application/helpers/jwt_helper.dart';
import '../../../application/logger/i_logger.dart';
import '../../../entities/user.dart';
import '../../../exceptions/service_exception.dart';
import '../../../exceptions/user_not_found_exception.dart';
import '../data/i_user_repository.dart';
import '../view_models/refresh_token_view_model.dart';
import '../view_models/update_url_avatar_view_model.dart';
import '../view_models/user_confirm_input_model.dart';
import '../view_models/user_refresh_token_input_model.dart';
import '../view_models/user_save_input_model.dart';

@LazySingleton(as: IUserService)
class IUserServiceImpl implements IUserService {
  IUserRepository userRepository;
  ILogger log;

  IUserServiceImpl({
    required this.userRepository,
    required this.log,
  });

  @override
  Future<User> createUser(UserSaveInputModel user) {
    try {
      final userEntity = User(
          email: user.email,
          password: user.password,
          registerType: 'App',
          supplierId: user.supplierId);

      return userRepository.createUser(userEntity);
    } catch (e, s) {
      log.error('Erro ao atualizar avatar', e, s);
      throw Response.internalServerError();
    }
  }

  @override
  Future<User> loginWithEmailPassword(
          String email, String password, bool supplier) =>
      userRepository.loginWithEmailPassword(email, password, supplier);

  @override
  Future<User> loginWithSocial(
      String email, String avatar, String socialType, String socialKey) async {
    try {
      return await userRepository.loginByEmailSocialKey(
          email, socialKey, socialType);
    } on UserNotFoundException catch (e) {
      log.error('Usuário não encontrado, criando um usuário', e);

      final user = User(
        email: email,
        imageAvatar: avatar,
        registerType: socialType,
        socialKey: socialKey,
        password: DateTime.now().toString(),
      );

      return await userRepository.createUser(user);
    }
  }

  @override
  Future<String> confirmLogin(UserConfirmInputModel inputModel) async {
    final refreshToken = JwtHelper.refreshToken(inputModel.acccessToken);
    final user = User(
      id: inputModel.userId,
      refreshToken: refreshToken,
      iosToken: inputModel.iosDeviceToken,
      androidToken: inputModel.androidDeviceToken,
    );

    await userRepository.updateUserDeviceTokenAndRefreshToken(user);
    return refreshToken;
  }

  @override
  Future<RefreshTokenViewModel> refreshToken(
      UserRefreshTokenInputModel model) async {
    _validateRefreshToken(model);
    final newAccessToken = JwtHelper.generateJWT(model.user, model.supplier);
    final newRefreshToken =
        JwtHelper.refreshToken(newAccessToken.replaceAll('Bearer ', ''));

    final user = User(
      id: model.user,
      refreshToken: newRefreshToken,
    );

    await userRepository.updateRefreshToken(user);

    return RefreshTokenViewModel(
        accessToken: newAccessToken, refreshToken: newRefreshToken);
  }

  void _validateRefreshToken(UserRefreshTokenInputModel model) {
    try {
      final refreshToken = model.refreshToken.split(' ');
      if (refreshToken.length != 2 || refreshToken.first != 'Bearer') {
        log.error('Refresh token inválido');
        throw ServiceException(message: 'Refresh token inválido');
      }

      final refreshTokenClaim = JwtHelper.getClaims(refreshToken.last);

      if (model.accessToken.contains(' ')) {
        refreshTokenClaim.validate(issuer: ' ${model.accessToken}');
      } else {
        refreshTokenClaim.validate(issuer: model.accessToken);
      }
    } on ServiceException {
      rethrow;
    } on JwtException catch (e, s) {
      print(e);
      print(s);
      log.error('Refresh token inválido', e);

      throw ServiceException(message: 'Refresh inválido');
    } catch (e) {
      throw ServiceException(message: 'Erro ao validar refresh Token');
    }
  }

  @override
  Future<User> findById(int id) => userRepository.findById(id);

  @override
  Future<User> updateAvatar(UpdateUrlAvatarViewModel viewModel) async {
    await userRepository.updateUrlAvatar(viewModel.userId, viewModel.urlAvatar);
    return findById(viewModel.userId);
  }

  @override
  Future<void> updateDeviceToken(UserUpdateDeviceInputModel model) =>
      userRepository.updateDeviceToken(
        model.userId,
        model.token,
        model.platform,
      );
}
