import 'dart:convert';

class InsuranceModel {
  InsuranceModel(
      {this.idUbezpieczenia,
      this.ubezpieczyciel,
      this.nrPolisy,
      this.dataZakupu,
      this.dataKonca,
      this.kosztPolisy,
      this.idRodzajuUbezpieczenia});
      

  String? idUbezpieczenia;
  String? ubezpieczyciel;
  String? nrPolisy;
  String? dataZakupu;
  String? dataKonca;
  int? idRodzajuUbezpieczenia;
  double? kosztPolisy;

  Map<String, dynamic> toJson() => {
        "ubezpieczyciel": ubezpieczyciel,
        "nrPolisy": nrPolisy,
        "dataZakupu": dataZakupu,
        "dataKonca": dataKonca,
        "kosztPolisy": kosztPolisy,
        "idRodzajuUbezpieczenia": idRodzajuUbezpieczenia,
      };

  factory InsuranceModel.fromJson(Map<String, dynamic> json) =>
      InsuranceModel(
          idUbezpieczenia: json["idUbezpieczenia"],
          ubezpieczyciel: json["ubezpieczyciel"],
          nrPolisy: json["nrPolisy"],
          dataZakupu: json["dataZakupu"],
          dataKonca: json["dataKonca"],
          kosztPolisy: json["kosztPolisy"],
          idRodzajuUbezpieczenia: json["idRodzajuUbezpieczenia"]);
}

List<InsuranceModel> insuranceListFromJson(String str) =>
    List<InsuranceModel>.from(
        json.decode(str).map((x) => InsuranceModel.fromJson(x)));
