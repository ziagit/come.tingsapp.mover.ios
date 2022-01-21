class Message {
  int id;
  int roomId;
  int userId;
  String message;
  String createdAt;
  String updatedAt;
  String userName;

  Message(this.id, this.roomId, this.userId, this.message, this.createdAt,
      this.updatedAt, this.userName);

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['room_id'];
    userId = json['user_id'];
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userName = json['user']['name'];
  }
}
