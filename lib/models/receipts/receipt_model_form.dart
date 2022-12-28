class ReceiptModelForm {
  ReceiptModelForm({
    this.nazwa,
    this.cena,
    this.waznoscZwrotu,
    this.waznoscGwarancji,
    this.dataZakupu,
    this.idKategorii,
    this.nazwaSklepu,
    this.uwagi,
  });

  String? nazwa;
  String? dataZakupu;
  double? cena;
  String? nazwaSklepu;
  int? idKategorii;
  String? uwagi;
  int? waznoscZwrotu;
  int? waznoscGwarancji;

  factory ReceiptModelForm.fromJson(Map<String, dynamic> json) =>
      ReceiptModelForm(
        nazwa: json["nazwa"],
        cena: json["cena"],
        waznoscZwrotu: json["waznoscZwrotu"],
        waznoscGwarancji: json["waznoscGwarancji"],
        dataZakupu: json["dataZakupu"],
        idKategorii: json["idKategorii"],
        nazwaSklepu: json["nazwaSklepu"],
        uwagi: json["uwagi"],
      );

  Map<String, dynamic> toJson() => {
        "nazwa": nazwa,
        "cena": cena,
        "waznoscZwrotu": waznoscZwrotu,
        "waznoscGwarancji": waznoscGwarancji,
        "dataZakupu": dataZakupu,
        "idKategorii": idKategorii,
        "uwagi": uwagi,
        "nazwaSklepu": nazwaSklepu
      };
}
