class AnalyticsData {
  final List<Map<String, dynamic>> salesData;
  final List<Map<String, dynamic>> topProducts;
  final List<Map<String, dynamic>> categoryRevenue;
  final double totalSales;
  final int totalOrders;
  final double avgOrder;

  AnalyticsData({
    required this.salesData,
    required this.topProducts,
    required this.categoryRevenue,
    required this.totalSales,
    required this.totalOrders,
    required this.avgOrder,
  });

  factory AnalyticsData.empty() {
    return AnalyticsData(
      salesData: [],
      topProducts: [],
      categoryRevenue: [],
      totalSales: 0,
      totalOrders: 0,
      avgOrder: 0,
    );
  }
}