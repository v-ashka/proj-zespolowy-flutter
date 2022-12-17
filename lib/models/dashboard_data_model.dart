import 'dart:convert';

class DashboardData {
  DashboardData(
      { this.ostatniDokument,
       this.ostatniParagon,
       this.markaModelSamochodu,
       this.dniDoPrzegladu,
       this.liczbaPomieszczen});

  String? ostatniDokument;
  String? ostatniParagon;
  String? markaModelSamochodu;
  int? dniDoPrzegladu;
  int? liczbaPomieszczen;

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
      ostatniDokument: json["ostatniDokument"],
      ostatniParagon: json["ostatniParagon"],
      markaModelSamochodu: json["markaModelSamochodu"],
      dniDoPrzegladu: json["dniDoPrzegladu"],
      liczbaPomieszczen: json["liczbaPomieszczen"]);

}