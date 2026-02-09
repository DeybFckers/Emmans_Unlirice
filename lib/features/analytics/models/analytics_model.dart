class AnalyticsData {
  final List<Map<String, dynamic>> monthlySalesData;
  final List<Map<String, dynamic>> monthlyPaymentData;
  final List<Map<String, dynamic>> monthlyProfitData;
  final List<Map<String, dynamic>> monthlyItemExpenses;
  final List<ShareholderProfit> shareholderProfits;
  final double totalRevenue;
  final double totalItemExpenses;
  final double totalNetProfit;
  final double totalCash;
  final double totalGcash;
  final int totalOrders;

  AnalyticsData({
    required this.monthlySalesData,
    required this.monthlyPaymentData,
    required this.monthlyProfitData,
    required this.monthlyItemExpenses,
    required this.shareholderProfits,
    required this.totalRevenue,
    required this.totalItemExpenses,
    required this.totalNetProfit,
    required this.totalCash,
    required this.totalGcash,
    required this.totalOrders,
  });
}

class ShareholderProfit {
  final int shareholderId;
  final String shareholderName;
  final double percentage;
  final double profitShare;

  ShareholderProfit({
    required this.shareholderId,
    required this.shareholderName,
    required this.percentage,
    required this.profitShare,
  });
}
