class ReceiptModel {
  ReceiptModel({
    this.idParagonu,
    this.nazwa,
    this.cena,
    this.koniecZwrotu,
    this.koniecGwarancji,
    this.dataZakupu,
    this.kategoriaParagonu,
    this.sklep,
    this.uwagi,
  });

  String? idParagonu;
  String? nazwa;
  String? dataZakupu;
  double? cena;
  String? sklep;
  String? kategoriaParagonu;
  String? uwagi;
  int? koniecZwrotu;
  int? koniecGwarancji;

  factory ReceiptModel.fromJson(Map<String, dynamic> json) => ReceiptModel(
        idParagonu: json["idParagonu"],
        nazwa: json["nazwa"],
        cena: json["cena"],
        koniecZwrotu: json["koniecZwrotu"],
        koniecGwarancji: json["koniecGwarancji"],
        dataZakupu: json["dataZakupu"],
        kategoriaParagonu: json["kategoriaParagonu"],
        uwagi: json["uwagi"],
        sklep: json["nazwaSklepu"],
      );

  Map<String, dynamic> toJson() => {
        "idParagonu": idParagonu,
        "nazwa": nazwa,
        "cena": cena,
        "koniecZwrotu": koniecZwrotu,
        "koniecGwarancji": koniecGwarancji,
        "dataZakupu": dataZakupu,
        "kategoriaParagonu": kategoriaParagonu,
        "uwagi": uwagi,
        "nazwaSklepu": sklep
      };
}
