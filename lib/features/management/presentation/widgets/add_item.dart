import 'package:coffee_pos/core/theme/input_style.dart';
import 'package:coffee_pos/core/theme/snackbar.dart';
import 'package:coffee_pos/features/management/data/models/InventoryItem_model.dart';
import 'package:coffee_pos/features/management/data/provider/inventoryitem_provider.dart';
import 'package:coffee_pos/features/management/data/provider/management_provider.dart';
import 'package:coffee_pos/features/management/utils/validator/item_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddInventoryItem extends ConsumerStatefulWidget {
  const AddInventoryItem({super.key});

  @override
  ConsumerState<AddInventoryItem> createState() => _AddInventoryItemState();
}

class _AddInventoryItemState extends ConsumerState<AddInventoryItem> {
  final nameController = TextEditingController();
  final costController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  @override
  void dispose(){
    nameController.dispose();
    costController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.brown.withOpacity(0.85),
      title: Text("Add Item"),
      content: SizedBox(
        width: screenSize.width * 0.35,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: customInputDecoration('Item Name', Icons.fastfood),
                validator: ItemValidator.name,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: costController,
                decoration: customInputDecoration('Item Cost', Icons.fastfood),
                validator: ItemValidator.cost,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if(formKey.currentState!.validate()){
              final inventoryitem = InventoryItemModel(
                id: 0, 
                name: nameController.text.trim(), 
                cost: double.parse(costController.text), 
                date: DateTime.now().toIso8601String(),
              );

              await ref.read(inventoryitemNotifierProvider.notifier).addInventoryItem(inventoryitem);
              await ref.read(inventoryitemNotifierProvider.notifier).fetchInventoryItem();
              ref.read(managementNotifierProvider.notifier).fetchAll();

              Navigator.pop(context);
              showCustomSnackBar(
                context,
                message: "Item Added Successfully",
                isSuccess: true,
                title: "Success!",
              );
            }
          }, 
          child: const Text(
            'Confirm',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 121, 85, 72),
          ),
        )
      ],
    );
  }
}