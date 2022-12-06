import 'dart:convert';

List<NotificationList> notificationListFromJson(String str) =>
    List<NotificationList>.from(
        json.decode(str).map((x) => NotificationList.fromJson(x)));

class NotificationList {
  String? naglowek;
  String? opis;
  NotificationList({this.naglowek, this.opis});

  factory NotificationList.fromJson(Map<String, dynamic> json) =>
      NotificationList(naglowek: json["naglowek"], opis: json["opis"]);
}
