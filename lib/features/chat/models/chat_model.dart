class ChatModel {
  String? chatId;
  String? lastMessage;
  List<dynamic>? members;
  String? receiver;

  ChatModel({required this.chatId,required this.members,required this.lastMessage,required this.receiver});

  ChatModel.fromJson(Map<String,dynamic> map){
    chatId = map['chatId'];
    members = map['members'];
    lastMessage = map['lastMessage'];
    receiver = map['receiver'];
  }

  
}