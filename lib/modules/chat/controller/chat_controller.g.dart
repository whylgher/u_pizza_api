// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ChatControllerRouter(ChatController service) {
  final router = Router();
  router.add(
    'POST',
    r'/schedule/<scheduleId|[0-9]+>/start-chat',
    service.startChatByScheduleId,
  );
  router.add(
    'POST',
    r'/notify',
    service.notifyUser,
  );
  return router;
}
