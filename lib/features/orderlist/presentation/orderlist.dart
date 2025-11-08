import 'package:coffee_pos/features/orderlist/provider/orderlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

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
            final filteredOrders = Map.fromEntries(
              groupedOrders.entries.map((entry) {
                final inProgressItems = entry.value
                    .where((item) => item.OrderStatus == 'In Progress')
                    .toList();
                return MapEntry(entry.key, inProgressItems);
              }).where((entry) => entry.value.isNotEmpty), // remove empty lists
            );
            if (filteredOrders.isEmpty) {
              return Center(child: Text('No In Progress Orders'));
            }
            final orderIds = filteredOrders.keys.toList();
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
                final items = filteredOrders[orderId]!;
                final firstItem = items.first;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text('Order Details')
                                ),
                                Text('${firstItem.OrderStatus}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                            content: SizedBox(
                              width: screenSize.width * 0.25,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Customer: ${firstItem.CustomerName}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Divider(thickness: 1.5),
                                  ...items.map(
                                        (item) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'x${item.Quantity} ${item.ProductName}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                          Text('₱${item.SubTotal}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(thickness: 1.5),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text('Payment Method: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                      ),
                                      Text('${firstItem.PaymentMethod}')
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text('Total: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ),
                                      Text('${firstItem.TotalAmount}')
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Close'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  try{
                                    await ref.read(orderListNotifierProvider.notifier)
                                        .updateOrderStatus(firstItem.OrderId!, 'Completed');

                                    Get.snackbar(
                                      "Success", "Order Complete",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );

                                    Navigator.pop(context);
                                  }catch(e){
                                    print('error updating $e');
                                  }
                                },
                                child: Text('Done',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 121, 85, 72),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                      child: Card(
                        color: Colors.white,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            firstItem.CustomerName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            firstItem.OrderType,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: firstItem.OrderType == 'Take Out' ? Colors.orange : Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
                                ...items.map((item) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Text(
                                    'x${item.Quantity} ${item.ProductName} - ₱${item.SubTotal}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                )),
                                Spacer(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${firstItem.OrderStatus}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: (){
                                        showDialog(
                                          context: context,
                                          builder: (_){
                                            return AlertDialog(
                                              title: Text('${firstItem.CustomerName} Orders'),
                                              content: Text('Are you sure you want to delete this order?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text('Close'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    try{
                                                      await ref.read(orderListNotifierProvider.notifier)
                                                          .updateOrderStatus(firstItem.OrderId!, 'Refund');

                                                      Get.snackbar(
                                                        "Success", "Order delete",
                                                        snackPosition: SnackPosition.BOTTOM,
                                                        backgroundColor: Colors.green,
                                                        colorText: Colors.white,
                                                      );

                                                      Navigator.pop(context);
                                                    }catch(e){
                                                      print('error updating $e');
                                                    }
                                                  },
                                                  child: Text('Confirm',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color.fromARGB(255, 121, 85, 72),
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                        );
                                      },
                                      icon: Icon(Icons.delete, color: Colors.red),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
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
