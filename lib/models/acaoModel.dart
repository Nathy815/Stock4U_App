class AcaoModel {

  String id;
  String ticker;
  String name;
  double value;
  double variation;
  double percentage;
  bool higher;
  int notes;
  List<AcaoModel> compare;

  AcaoModel({this.id, this.ticker, this.name, this.value, this.variation, this.percentage, this.higher, this.notes, this.compare});
}