class NotificationModel {
  final String receiverId;

  final String senderId;

  final String notificationText;
  final DateTime notificationDate;

  NotificationModel({
    required this.notificationDate,
    required this.notificationText,
    required this.receiverId,
    required this.senderId,
  });

  Map<String,dynamic> toJson(){
    return {
      'receiverId':receiverId,
      'senderId':senderId,
      'notificationText':notificationText,
      'notificationDate':notificationDate,
    };
  }
}
