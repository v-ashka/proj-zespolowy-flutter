import 'dart:convert';

class DocumentModel {
  DocumentModel({
    this.idDokumentu,
    this.nazwaDokumentu,
    this.dataUtworzenia,
    this.kategoria,
    this.opis,
    this.wartoscFaktury,
    this.numerFaktury,
    this.sprzedawcaNaFakturze,
    this.dataWystawienia,
    this.dataStartu,
    this.dataKonca,
    this.dataPrzypomnienia,
    this.wysokoscRachunku
    });


  String? idDokumentu;
  String? nazwaDokumentu;
  String? dataUtworzenia;
  int? kategoria;
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
        "kategoria": kategoria,
        "opis": opis,
        "wartoscFaktury": wartoscFaktury,
        "numerFaktury": numerFaktury,
        "sprzedawcaNaFakturze": sprzedawcaNaFakturze,
        "dataWystawieniaFaktury": dataWystawienia,
        "dataZakupuPolisy": dataStartu,
        "dataKoncaPolisy": dataKonca,
        "dataPrzypomnienia": dataPrzypomnienia,
        "wysokoscRachunku": wysokoscRachunku

      };

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      DocumentModel(
          idDokumentu: json["idDokumentu"],
          nazwaDokumentu: json["nazwaDokumentu"],
          dataUtworzenia: json["dataUtworzenia"],
          kategoria: json["kategoria"],
          opis: json["opis"],
          wartoscFaktury: json["wartoscFaktury"],
          numerFaktury: json["numerFaktury"],
          sprzedawcaNaFakturze: json["sprzedawcaNaFakturze"],
          dataWystawienia: json["dataWystawieniaFaktury"],
          dataStartu: json["dataZakupuPolisy"],
          dataKonca: json["dataKoncaPolisy"],
          dataPrzypomnienia: json["dataPrzypomnienia"],
          wysokoscRachunku: json["wysokoscRachunku"]);
}

List<DocumentModel> documentListFromJson(String str) =>
    List<DocumentModel>.from(
        json.decode(str).map((x) => DocumentModel.fromJson(x)));
