import 'package:coffee_pos/core/database/inventoryitem_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coffee_pos/core/database/analytics_table.dart';
import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/core/database/shareholder_table.dart';
import 'package:coffee_pos/features/analytics/models/analytics_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class AnalyticsNotifier extends StateNotifier<AsyncValue<AnalyticsData>> {
  AnalyticsNotifier() : super(const AsyncValue.loading());

  Future<void> loadAnalytics(String selectedMonth) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final db = await StreetSideDatabase.instance.database;

      // Fetch monthly sales data
      final monthlySales = await db.query(
        AnalyticsTable.MonthlySalesTableName,
        limit: 12,
        orderBy: 'Month DESC',
      );

      // Fetch monthly payment data
      final monthlyPayments = await db.query(
        AnalyticsTable.MonthlyPaymentTableName,
        limit: 12,
        orderBy: 'Month DESC',
      );

      // Fetch monthly profit data
      final monthlyProfit = await db.query(
        AnalyticsTable.MonthlyProfitTableName,
        limit: 12,
        orderBy: 'Month DESC',
      );

      // Fetch monthly item expenses with details
      final monthlyExpenses = await db.rawQuery('''
      SELECT
        strftime('%Y-%m', ${InventoryItemTable.InventoryItemDate}) AS Month,
        ${InventoryItemTable.InventoryItemName} AS Item_Name,
        ${InventoryItemTable.InventoryItemCost} AS Item_Cost,
        ${InventoryItemTable.InventoryItemDate} AS Item_Date
      FROM ${InventoryItemTable.InventoryItemTableName}
      ORDER BY ${InventoryItemTable.InventoryItemDate} DESC
      ''');

      // Calculate totals for selected month
      double totalRevenue = 0.0;
      double totalItemExpenses = 0.0;
      double totalNetProfit = 0.0;
      double totalCash = 0.0;
      double totalGcash = 0.0;
      int totalOrders = 0;

      // Find data for selected month
      for (var profit in monthlyProfit) {
        if (profit['Month'] == selectedMonth) {
          totalRevenue = (profit['Revenue'] as num?)?.toDouble() ?? 0.0;
          totalItemExpenses = (profit['Item_Expenses'] as num?)?.toDouble() ?? 0.0;
          totalNetProfit = (profit['Net_Profit'] as num?)?.toDouble() ?? 0.0;
          break;
        }
      }

      for (var payment in monthlyPayments) {
        if (payment['Month'] == selectedMonth) {
          totalCash = (payment['Total_Cash'] as num?)?.toDouble() ?? 0.0;
          totalGcash = (payment['Total_Gcash'] as num?)?.toDouble() ?? 0.0;
          break;
        }
      }

      for (var sales in monthlySales) {
        if (sales['Month'] == selectedMonth) {
          totalOrders = (sales['Total_Orders'] as int?) ?? 0;
          break;
        }
      }

      // Fetch shareholders and calculate profit distribution
      final shareholders = await db.query(
        ShareholderTable.ShareholderTableName,
        orderBy: '${ShareholderTable.ShareholderPercentage} DESC',
      );

      final shareholderProfits = shareholders.map((shareholder) {
        final percentage = (shareholder[ShareholderTable.ShareholderPercentage] as num).toDouble();
        final profitShare = (totalNetProfit * percentage) / 100;

        return ShareholderProfit(
          shareholderId: shareholder[ShareholderTable.ShareholderID] as int,
          shareholderName: shareholder[ShareholderTable.ShareholderName] as String,
          percentage: percentage,
          profitShare: profitShare,
        );
      }).toList();

      return AnalyticsData(
        monthlySalesData: monthlySales,
        monthlyPaymentData: monthlyPayments,
        monthlyProfitData: monthlyProfit,
        monthlyItemExpenses: monthlyExpenses,
        shareholderProfits: shareholderProfits,
        totalRevenue: totalRevenue,
        totalItemExpenses: totalItemExpenses,
        totalNetProfit: totalNetProfit,
        totalCash: totalCash,
        totalGcash: totalGcash,
        totalOrders: totalOrders,
      );
    });
  }
}

final selectedMonthProvider = StateProvider<String>((ref) {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
});

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsData>>(
        (ref) => AnalyticsNotifier());
