class ChatData {
  String username;
  String message;
  String datetime;
  ChatData(this.username, this.message, this.datetime);
  factory ChatData.fromJson(dynamic json) {
    return ChatData(json['username'] as String, json['message'] as String, json['datetime'] as String);
  }
  @override
  String toString() {
    return '{ username is $username';
  }
  String getUsername() {
    return username;
  }
  String getMessage() {
    return message;
  }
  String getDatetime() {
    return datetime;
  }
}