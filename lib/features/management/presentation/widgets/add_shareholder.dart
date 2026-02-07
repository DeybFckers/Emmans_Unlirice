import 'package:coffee_pos/core/theme/input_style.dart';
import 'package:coffee_pos/core/theme/snackbar.dart';
import 'package:coffee_pos/features/management/data/models/shareholder_model.dart';
import 'package:coffee_pos/features/management/data/provider/shareholder_provider.dart';
import 'package:coffee_pos/features/management/data/provider/management_provider.dart';
import 'package:coffee_pos/features/management/utils/validator/shareholder_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddShareholder extends ConsumerStatefulWidget {
  const AddShareholder({super.key});

  @override
  ConsumerState<AddShareholder> createState() => _AddShareholderState();
}

class _AddShareholderState extends ConsumerState<AddShareholder> {
  final nameController = TextEditingController();
  final percentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    percentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: Colors.brown.withOpacity(0.85),
      title: Text('Add Shareholder'),
      content: SizedBox(
        width: screenSize.width * 0.35,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: customInputDecoration('Shareholder Name', Icons.person),
                validator: ShareholderValidator.name,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: percentController,
                decoration: customInputDecoration('Percentage', Icons.percent),
                keyboardType: TextInputType.number,
                validator: ShareholderValidator.percentage,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: Colors.black))),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final sh = ShareholderModel(id: 0, name: nameController.text.trim(), percentage: double.parse(percentController.text));
              await ref.read(shareholderNotifierProvider.notifier).addShareholder(sh);
              ref.read(managementNotifierProvider.notifier).fetchAll();

              Navigator.pop(context);
              showCustomSnackBar(context, message: 'Shareholder Added Successfully', isSuccess: true, title: 'Success!');
            }
          },
          child: Text('Confirm', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 121, 85, 72)),
        )
      ],
    );
  }
}
