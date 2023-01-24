import 'dart:convert';

class DocumentModel {
  DocumentModel({
    this.idDokumentu,
    this.nazwaDokumentu,
    this.dataUtworzenia,
    this.idKategorii,
    this.opis,
    this.wartoscFaktury,
    this.numerFaktury,
    this.sprzedawcaNaFakturze,
    this.dataWystawienia,
    this.dataStartu,
    this.dataKonca,
    this.dataPrzypomnienia,
    this.wysokoscRachunku,
    this.wartoscPolisy,
    this.ubezpieczyciel
    });


  String? idDokumentu;
  String? nazwaDokumentu;
  String? dataUtworzenia;
  int? idKategorii;
  String? opis;
  String? numerFaktury;
  String? wartoscFaktury;
  String? sprzedawcaNaFakturze;
  String? dataWystawienia;
  String? ubezpieczyciel;
  String? wartoscPolisy;
  String? dataStartu;
  String? dataKonca;
  String? dataPrzypomnienia;
  String? wysokoscRachunku;

  Map<String, dynamic> toJson() =>
      {
        "nazwaDokumentu": nazwaDokumentu,
        "idKategorii": idKategorii,
        "opis": opis,
        "wartoscFaktury": wartoscFaktury,
        "ubezpieczyciel": ubezpieczyciel,
        "numerFaktury": numerFaktury,
        "sprzedawcaNaFakturze": sprzedawcaNaFakturze,
        "dataWystawienia": dataWystawienia,
        "dataStartu": dataStartu,
        "dataKonca": dataKonca,
        "dataPrzypomnienia": dataPrzypomnienia,
        "wysokoscRachunku": wysokoscRachunku,
        "wartoscPolisy": wartoscPolisy

      };

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      DocumentModel(
          idDokumentu: json["idDokumentu"],
          nazwaDokumentu: json["nazwaDokumentu"],
          dataUtworzenia: json["dataUtworzenia"],
          idKategorii: json["idKategorii"],
          ubezpieczyciel: json["ubezpieczyciel"],
          opis: json["opis"],
          wartoscFaktury: json["wartoscFaktury"],
          numerFaktury: json["numerFaktury"],
          sprzedawcaNaFakturze: json["sprzedawcaNaFakturze"],
          dataWystawienia: json["dataWystawienia"],
          dataStartu: json["dataStartu"],
          dataKonca: json["dataKonca"],
          dataPrzypomnienia: json["dataPrzypomnienia"],
          wysokoscRachunku: json["wysokoscRachunku"],
          wartoscPolisy: json["wartoscPolisy"]);
}

List<DocumentModel> documentListFromJson(String str) =>
    List<DocumentModel>.from(
        json.decode(str).map((x) => DocumentModel.fromJson(x)));
