import 'dart:convert';

List<ReceiptListView> receiptListViewFromJson(String str) =>
    List<ReceiptListView>.from(
        json.decode(str).map((x) => ReceiptListView.fromJson(x)));

class ReceiptListView {
  ReceiptListView({
    required this.idParagonu,
    required this.nazwa,
    required this.cena,
    required this.koniecZwrotu,
    required this.koniecGwarancji,
    required this.idKategorii,
    required this.idSklepu,
  });

  String? idParagonu;
  String? nazwa;
  double? cena;
  int? koniecZwrotu;
  int? koniecGwarancji;
  int? idSklepu;
  int? idKategorii;

  factory ReceiptListView.fromJson(Map<String, dynamic> json) =>
      ReceiptListView(
        idParagonu: json["idParagonu"],
        nazwa: json["nazwa"],
        cena: json["cena"],
        koniecZwrotu: json["koniecZwrotu"],
        koniecGwarancji: json["koniecGwarancji"],
        idSklepu: json["idSklepu"],
        idKategorii: json["idKategorii"],
      );
}
