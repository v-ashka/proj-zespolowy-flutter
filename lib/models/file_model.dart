import 'dart:convert';

class FileList {
  FileList(
      {required this.idPliku,
      required this.nazwaPlikuUzytkownika,
      required this.rozszerzenie,
      required this.wielkosc});

  String idPliku;
  String nazwaPlikuUzytkownika;
  String rozszerzenie;
  int wielkosc;

  factory FileList.fromJson(Map<String, dynamic> json) => FileList(
      idPliku: json["idPliku"],
      nazwaPlikuUzytkownika: json["nazwaPlikuUzytkownika"],
      rozszerzenie: json["rozszerzenie"],
      wielkosc: json["wielkosc"]);

  Map<String, dynamic> toJson() => {
        "idPliku": idPliku,
        "nazwaPlikuUzytkownika": nazwaPlikuUzytkownika,
        "rozszerzenie": rozszerzenie,
        "wielkosc": wielkosc
      };
}

List<FileList> fileListFromJson(String str) =>
    List<FileList>.from(json.decode(str).map((x) => FileList.fromJson(x)));

String fileListToJson(List<FileList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));