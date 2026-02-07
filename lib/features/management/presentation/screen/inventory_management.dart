import 'package:coffee_pos/core/theme/snackbar.dart';
import 'package:coffee_pos/core/widgets/customTableContainer.dart';
import 'package:coffee_pos/core/widgets/edit_button.dart';
import 'package:coffee_pos/core/widgets/edit_dialog.dart';
import 'package:coffee_pos/features/management/data/models/InventoryItem_model.dart';
import 'package:coffee_pos/features/management/data/provider/inventoryitem_provider.dart';
import 'package:coffee_pos/features/management/data/provider/management_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Widget buildInventoryTable(
  BuildContext context,
  WidgetRef ref,
  List<InventoryItemModel> inventoryitem,
  Size screenSize,
) {
  return CustomTableContainer(
    height: screenSize.height * 0.67,
    columns: const [
      DataColumn(
        label: Text(
          'Name',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Cost',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Date',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Actions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    ],
    rows: inventoryitem.map((p) {
      return DataRow(
        cells: [
          DataCell(
            Text(
              p.name,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          DataCell(
            Text(
              p.cost.toStringAsFixed(2),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          DataCell(
            Text(
              DateFormat('MMM dd, yyyy – hh:mm a')
                  .format(DateTime.parse(p.date)),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          DataCell(Row(
            children: [
              IconButton(
                onPressed: (){
                  final nameController = TextEditingController(text: p.name);
                  showEditDialog(
                    context,
                    title: 'Edit Name',
                    label: 'Item Name',
                    controller: nameController,
                    validator: (v) => v == null || v.isEmpty ? 'Please enter Item Name' : null,
                    icon: Icons.fastfood,
                    onConfirm: (){
                      ref.read(inventoryitemNotifierProvider.notifier).updateInventoryItem(p.id, nameController.text.trim(), p.cost);
                      ref.read(inventoryitemNotifierProvider.notifier).fetchInventoryItem();
                      ref.read(managementNotifierProvider.notifier).fetchAll();
                      showCustomSnackBar(context, message: 'Item Name Updated!', isSuccess: true, title: 'Success!');
                    }
                  );
                },
                icon: Icon(Icons.edit, color: Colors.green),
              ),
              IconButton(
                onPressed: (){
                  final costController = TextEditingController(text: p.cost.toString());
                  showEditDialog(
                    context,
                    title: 'Edit Cost',
                    label: 'Item Cost',
                    controller: costController,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Please enter Product Cost';
                      final number = double.tryParse(v);
                      if (number == null || number <= 0) return 'Please enter a valid Cost';
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    icon: Icons.attach_money,
                    onConfirm: (){
                      final val = double.tryParse(costController.text) ?? p.cost;
                      ref.read(inventoryitemNotifierProvider.notifier).updateInventoryItem(p.id, p.name, val);
                      ref.read(inventoryitemNotifierProvider.notifier).fetchInventoryItem();
                      ref.read(managementNotifierProvider.notifier).fetchAll();
                      showCustomSnackBar(context, message: 'Item Cost Updated!', isSuccess: true, title: 'Success!');
                    }
                  );
                },
                icon: Icon(Icons.attach_money, color: Colors.orange),
              ),
              IconButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.brown.withOpacity(0.85),
                      title: Text('Delete Item'),
                      content: Text('Are you sure you want to Delete?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel', style: TextStyle(color: Colors.red)),
                        ),
                        EditButton(
                          text: 'Confirm',
                          onPressed: (){
                            Navigator.pop(context);
                            ref.read(inventoryitemNotifierProvider.notifier).deleteInventoryItem(p.id);
                            ref.read(inventoryitemNotifierProvider.notifier).fetchInventoryItem();
                            ref.read(managementNotifierProvider.notifier).fetchAll();
                            showCustomSnackBar(context, message: 'Item Removed Successfully!', isSuccess: true, title: 'Success!');
                          }
                        )
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.delete, color: Colors.red),
              )
            ],
          ))
        ],
      );
    }).toList(),
  );
}
