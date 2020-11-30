class AcaoModel {

  String id;
  String ticker;
  String name;
  int notes;
  int alerts;
  List<AcaoItemModel> itens;
  List<AcaoCompareModel> compare;

  AcaoModel({this.id, this.ticker, this.name, this.notes, this.alerts, this.itens, this.compare});
}

class AcaoItemModel {
  String label;
  double value;
  double percentage;
  bool higher;

  AcaoItemModel({this.label, this.value, this.percentage, this.higher});
}

class AcaoCompareModel {
  String id;
  String ticker;
  String name;
  double value;
  double variation;
  double percentage;
  bool higher;

  AcaoCompareModel({this.id, this.ticker, this.name, this.value, this.variation, this.percentage, this.higher});
}