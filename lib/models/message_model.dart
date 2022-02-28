class MessageModel {
  final String senderUID;
  final String receiverUID;
  final String message;
  final DateTime date;

  MessageModel(this.senderUID, this.receiverUID, this.message, this.date);

  Map<String,dynamic> toJason(){
    return {
      'senderUID':senderUID,
      'receiverUID':receiverUID,
      'message':message,
      'date':date,
    };
  }
}
