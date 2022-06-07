class MessageData {
  String sender;
  String addressee;
  String message;
  String datetime;

  MessageData(this.sender, this.addressee, this.message, this.datetime);

  factory MessageData.fromJson(dynamic json) {
    return MessageData(json['sender'] as String, json['addressee'] as String,
        json['message'] as String, json['datetime'] as String);
  }

  @override
  String toString() {
    return 'sender: $sender, addressee: $addressee, message: $message, datetime: $datetime';
  }

  String getSender() {
    return sender;
  }

  String getAddressee() {
    return addressee;
  }

  String getMessage() {
    return message;
  }

  String getDatetime() {
    return datetime;
  }
}