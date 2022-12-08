import 'dart:convert';

class RoomModel {
  RoomModel(
      {this.idPokoju,
        this.nazwaPokoju,
      });

  String? idPokoju;
  String? nazwaPokoju;

  Map<String, dynamic> toJson() => {
    "idPokoju": idPokoju,
    "nazwaPokoju": nazwaPokoju,
  };

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      RoomModel(
          idPokoju: json["idPokoju"],
          nazwaPokoju: json["nazwaPokoju"],
      );
}

List<RoomModel> roomListFromJson(String str) =>
    List<RoomModel>.from(
        json.decode(str).map((x) => RoomModel.fromJson(x)));
