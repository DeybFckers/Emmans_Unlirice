import 'package:coffee_pos/features/management/presentation/widgets/add_item.dart';
import 'package:coffee_pos/features/management/presentation/widgets/add_product.dart';
import 'package:coffee_pos/features/management/presentation/widgets/add_shareholder.dart';
import 'package:flutter/material.dart';

class AddChoiceDialog extends StatelessWidget {
  const AddChoiceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.brown.withOpacity(0.85),
      title: const Text('Add'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.fastfood),
            title: const Text('Add Product'),
            onTap: () {
              Navigator.pop(context); // close choice dialog
              showDialog(
                context: context,
                builder: (_) => const AddProduct(),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Add Inventory Item'),
            onTap: () {
              Navigator.pop(context); // close choice dialog
              showDialog(
                context: context,
                builder: (_) => const AddInventoryItem(),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Add Shareholder'),
            onTap: () {
              Navigator.pop(context); // close choice dialog
              showDialog(
                context: context,
                builder: (_) => const AddShareholder(),
              );
            },
          ),
        ],
      ),
    );
  }
}
