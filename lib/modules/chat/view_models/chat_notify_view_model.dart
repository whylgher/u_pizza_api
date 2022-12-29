import '../../../application/helpers/request_mapping.dart';

enum NoficationUserType { user, supplier }

class ChatNotifyViewModel extends RequestMapping {
  late int chat;
  late String message;
  late NoficationUserType noficationUserType;

  ChatNotifyViewModel(String dataRequest) : super(dataRequest);

  @override
  void map() {
    chat = data['chat'];
    message = data['message'];
    String noficationUserTypeRq = data['to'];
    noficationUserType = noficationUserTypeRq.toLowerCase() == 'u'
        ? NoficationUserType.user
        : NoficationUserType.supplier;
  }
}
