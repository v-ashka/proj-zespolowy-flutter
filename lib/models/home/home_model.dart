import 'dart:convert';

List<HomeListView> homeListViewFromJson(String str) => List<HomeListView>.from(
    json.decode(str).map((x) => HomeListView.fromJson(x)));

class HomeListView {
  String? idDomu;
  String? ulicaNrDomu;
  String? miejscowosc;

  HomeListView({
    this.idDomu,
    this.ulicaNrDomu,
    this.miejscowosc,
  });

  factory HomeListView.fromJson(Map<String, dynamic> json) => HomeListView(
        idDomu: json["idDomu"],
        ulicaNrDomu: json["ulicaNrDomu"],
        miejscowosc: json["miejscowosc"],
      );
}
