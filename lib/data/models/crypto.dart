class Crypto {
  String id;
  String name;
  String symbol;
  double changePercent24hr;
  double priceUsd;
  double marketCapUsd;
  int rank;

  Crypto(
    this.id,
    this.name,
    this.symbol,
    this.changePercent24hr,
    this.priceUsd,
    this.marketCapUsd,
    this.rank,
  );

  factory Crypto.fromMapData(Map<String, dynamic> mapobject) {
    return Crypto(
      mapobject['id'],
      mapobject['name'],
      mapobject['symbol'],
      double.parse(mapobject['changePercent24Hr']),
      double.parse(mapobject['priceUsd']),
      double.parse(mapobject['marketCapUsd']),
      int.parse(mapobject['rank']),
    );
  }
}
