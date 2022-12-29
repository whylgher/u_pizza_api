// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuidapet_api/entities/chat.dart';
import 'package:cuidapet_api/modules/chat/view_models/chat_notify_view_model.dart';
import 'package:injectable/injectable.dart';

import './i_chat_service.dart';
import '../data/i_chat_repository.dart';

@LazySingleton(as: IChatService)
class IChatServiceImpl implements IChatService {
  final IChatRepository repository;

  IChatServiceImpl({
    required this.repository,
  });

  @override
  Future<int> startChat(int scheduleId) => repository.startChat(scheduleId);

  @override
  Future<void> notifyChat(ChatNotifyViewModel model) async {
    final chat = await repository.findChatById(model.chat);

    if (chat != null) {
      switch (model.noficationUserType) {
        case NoficationUserType.user:
          _notifyUser(chat.userDeviceToken?.tokens, model, chat);
          break;
        case NoficationUserType.supplier:
          break;
        default:
          throw Exception('Tipo notifica não encontrada');
      }
    }
  }

  void _notifyUser(
      List<String?>? tokens, ChatNotifyViewModel model, Chat chat) {}
}
