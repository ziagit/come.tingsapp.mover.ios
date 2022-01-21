class Room {
  int id;
  String name;
  int creator;
  int userId;
  String userPhone;
  String status;
  String createdAt;
  String updatedAt;
  String userName;

  Room(this.id, this.name, this.creator, this.userId, this.userPhone,
      this.status, this.createdAt, this.updatedAt, this.userName);

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    creator = json['creator'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    userName = json['user']['name'];
    userPhone = json['user']['phone'];
  }
}
