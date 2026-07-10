class TradingInfo {
  const TradingInfo({
    required this.symbol,
    required this.referencePrice,
    required this.ceilingPrice,
    required this.floorPrice,
    required this.stepPrice,
    required this.minVolume,
    required this.maxVolume,
    required this.availableBuyVolume,
    required this.availableSellVolume,
    required this.buyingPower,
    required this.sellableVolume,
  });

  /// Mã CK
  final String symbol;

  /// Giá tham chiếu
  final double referencePrice;

  /// Giá trần
  final double ceilingPrice;

  /// Giá sàn
  final double floorPrice;

  /// Bước giá (0.1, 0.05...)
  final double stepPrice;

  /// KL đặt tối thiểu
  final int minVolume;

  /// KL đặt tối đa
  final int maxVolume;

  /// Khối lượng còn có thể mua
  final int availableBuyVolume;

  /// Khối lượng còn có thể bán
  final int availableSellVolume;

  /// Sức mua
  final double buyingPower;

  /// Khối lượng có thể bán
  final int sellableVolume;
}