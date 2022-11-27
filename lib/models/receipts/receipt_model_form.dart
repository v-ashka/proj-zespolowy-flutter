class ReceiptModelForm {
  ReceiptModelForm({
    this.nazwa,
    this.cena,
    this.waznoscZwrotu,
    this.waznoscGwarancji,
    this.dataZakupu,
    this.nazwaKategorii,
    this.nazwaSklepu,
    this.uwagi,
  });

  String? nazwa;
  String? dataZakupu;
  double? cena;
  String? nazwaSklepu;
  String? nazwaKategorii;
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
        nazwaKategorii: json["nazwaKategorii"],
        nazwaSklepu: json["nazwaSklepu"],
        uwagi: json["uwagi"],
      );

  Map<String, dynamic> toJson() => {
        "nazwa": nazwa,
        "cena": cena,
        "waznoscZwrotu": waznoscZwrotu,
        "waznoscGwarancji": waznoscGwarancji,
        "dataZakupu": dataZakupu,
        "nazwaKategorii": nazwaKategorii,
        "uwagi": uwagi,
        "nazwaSklepu": nazwaSklepu
      };
}
