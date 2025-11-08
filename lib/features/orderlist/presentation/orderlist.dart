import 'package:coffee_pos/features/orderlist/provider/orderlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderlistState = ref.watch(orderListNotifierProvider);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 78, 52, 46),
        title: Text(
          'Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: orderlistState.when(
          data: (groupedOrders) {
            if (groupedOrders.isEmpty) {
              return Center(child: Text('No Orders'));
            }
            final orderIds = groupedOrders.keys.toList();
            return GridView.builder(
              itemCount: orderIds.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (screenSize.width ~/ 180).clamp(2, 8),
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final orderId = orderIds[index];
                final items = groupedOrders[orderId]!;
                final firstItem = items.first;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle order tap
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    firstItem.CustomerName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  '₱${firstItem.TotalAmount}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Divider(thickness: 1.5),
                            ...items.map(
                                  (item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  '${item.ProductName} x${item.Quantity} - ₱${item.SubTotal}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text("Error: $e")),
        ),
      ),
    );
  }
}
