import '../../../entities/chat.dart';

abstract class IChatRepository {
  Future<int> startChat(int scheduleId);

  Future<Chat?> findChatById(int chatId);
}
