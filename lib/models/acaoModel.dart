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

  String valueToString() {
    if (value > 999) // mil
    {
      if (value > 999999) // milhões
      {
        if (value > 999999999) // bilhões
        {
          if (value > 999999999999) // trilhões
            return (value / 1000000000).toStringAsFixed(2) + " tri";   
          return (value / 10000000).toStringAsFixed(2) + " bi";
        }
        return (value / 100000).toStringAsFixed(2) + " mi";
      }
      return (value / 1000).toStringAsFixed(2) + " k";
    }
    return value.toString();
  }
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