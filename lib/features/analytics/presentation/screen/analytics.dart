import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coffee_pos/features/analytics/provider/analytics_provider.dart';
import 'package:coffee_pos/features/analytics/models/analytics_model.dart';
import 'package:coffee_pos/features/analytics/presentation/widgets/profit_summary_card.dart';
import 'package:coffee_pos/features/analytics/presentation/widgets/shareholder_profit_list.dart';
import 'package:coffee_pos/features/analytics/presentation/widgets/profit_breakdown_chart.dart';
import 'package:coffee_pos/features/analytics/presentation/widgets/month_selector.dart';
import 'package:coffee_pos/features/analytics/presentation/widgets/item_expenses_list.dart';
import 'package:coffee_pos/features/analytics/presentation/widgets/payment_breakdown.dart';
import 'package:coffee_pos/core/widgets/my_drawer.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedMonth = ref.read(selectedMonthProvider);
      ref.read(analyticsProvider.notifier).loadAnalytics(selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final analyticsData = ref.watch(analyticsProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4E342E),
        title: Text(
          'Shareholder Analytics',
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ),
      drawer: MyDrawer(),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 245, 237, 224),
        ),
        child: analyticsData.when(
          data: (data) => _buildContent(context, data, selectedMonth),
          loading: () =>
              const Center(child: CircularProgressIndicator(strokeWidth: 3)),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, AnalyticsData data, String selectedMonth) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(analyticsProvider.notifier).loadAnalytics(selectedMonth);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Selector
            MonthSelector(
              selectedMonth: selectedMonth,
              availableMonths: data.monthlySalesData
                  .map((e) => e['Month'] as String)
                  .toList(),
              onChanged: (newMonth) async {
                ref.read(selectedMonthProvider.notifier).state = newMonth;
                await ref
                    .read(analyticsProvider.notifier)
                    .loadAnalytics(newMonth);
              },
            ),
            const SizedBox(height: 20),
            
            // Profit Summary Cards
            Row(
              children: [
                Expanded(
                  child: ProfitSummaryCard(
                    title: 'Revenue',
                    value: '₱${data.totalRevenue.toStringAsFixed(2)}',
                    icon: Icons.trending_up,
                    color: const Color(0xFF4CAF50),
                    subtitle: 'Total sales',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ProfitSummaryCard(
                    title: 'Expenses',
                    value: '₱${(data.totalProductCosts + data.totalItemExpenses).toStringAsFixed(2)}',
                    icon: Icons.trending_down,
                    color: const Color(0xFFF44336),
                    subtitle: 'Total costs',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ProfitSummaryCard(
                    title: 'Net Profit',
                    value: '₱${data.totalNetProfit.toStringAsFixed(2)}',
                    icon: Icons.account_balance_wallet,
                    color: const Color(0xFF2196F3),
                    subtitle: 'To distribute',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Profit Breakdown Chart
            ProfitBreakdownChart(
              revenue: data.totalRevenue,
              productCosts: data.totalProductCosts,
              itemExpenses: data.totalItemExpenses,
              netProfit: data.totalNetProfit,
            ),
            const SizedBox(height: 24),
            
            // Payment Breakdown
            PaymentBreakdown(
              totalCash: data.totalCash,
              totalGcash: data.totalGcash,
            ),
            const SizedBox(height: 24),
            
            // Shareholder Profit Distribution
            ShareholderProfitList(
              shareholders: data.shareholderProfits,
              totalProfit: data.totalNetProfit,
            ),
            const SizedBox(height: 24),
            
            // Item Expenses List
            ItemExpensesList(
              expenses: data.monthlyItemExpenses
                  .where((e) => e['Month'] == selectedMonth)
                  .toList(),
              totalExpenses: data.totalItemExpenses,
            ),
          ],
        ),
      ),
    );
  }
}
