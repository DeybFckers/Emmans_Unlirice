import 'package:coffee_pos/core/widgets/customTableContainer.dart';
import 'package:coffee_pos/features/management/data/models/shareholder_model.dart';
import 'package:coffee_pos/features/management/data/provider/shareholder_provider.dart';
import 'package:coffee_pos/features/management/data/provider/management_provider.dart';
import 'package:coffee_pos/core/theme/snackbar.dart';
import 'package:coffee_pos/core/widgets/edit_button.dart';
import 'package:coffee_pos/core/widgets/edit_dialog.dart';
import 'package:coffee_pos/features/management/utils/validator/shareholder_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildShareholderTable(BuildContext context, WidgetRef ref, List<ShareholderModel> items, Size screenSize) {
  return CustomTableContainer(
    height: screenSize.height * 0.67,
    columns: const [
      DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15))),
      DataColumn(label: Text('Percentage', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15))),
      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15))),
    ],
    rows: items.map((s) {
      return DataRow(cells: [
        DataCell(Text(s.name, style: const TextStyle(fontSize: 12))),
        DataCell(Text('${s.percentage.toStringAsFixed(2)}%', style: const TextStyle(fontSize: 12))),
        DataCell(Row(children: [
          IconButton(
            onPressed: (){
              final nameController = TextEditingController(text: s.name);
              showEditDialog(
                context,
                title: 'Edit Name',
                label: 'Shareholder Name',
                controller: nameController,
                validator: ShareholderValidator.name,
                icon: Icons.person,
                onConfirm: () {
                  ref.read(shareholderNotifierProvider.notifier).updateShareholder(s.id, nameController.text.trim(), s.percentage);
                  ref.read(shareholderNotifierProvider.notifier).fetchShareholders();
                  ref.read(managementNotifierProvider.notifier).fetchAll();
                  showCustomSnackBar(context, message: 'Shareholder Name Updated!', isSuccess: true, title: 'Success!');
                },
              );
            },
            icon: Icon(Icons.edit, color: Colors.green),
          ),
          IconButton(
            onPressed: (){
              final percentController = TextEditingController(text: s.percentage.toString());
              showEditDialog(
                context,
                title: 'Edit Percentage',
                label: 'Percentage',
                controller: percentController,
                validator: ShareholderValidator.percentage,
                keyboardType: TextInputType.number,
                icon: Icons.percent,
                onConfirm: () {
                  final val = double.tryParse(percentController.text) ?? s.percentage;
                  ref.read(shareholderNotifierProvider.notifier).updateShareholder(s.id, s.name, val);
                  ref.read(shareholderNotifierProvider.notifier).fetchShareholders();
                  ref.read(managementNotifierProvider.notifier).fetchAll();
                  showCustomSnackBar(context, message: 'Shareholder Percentage Updated!', isSuccess: true, title: 'Success!');
                },
              );
            },
            icon: Icon(Icons.percent, color: Colors.orange),
          ),
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.brown.withOpacity(0.85),
                  title: Text('Delete Shareholder'),
                  content: Text('Are you sure you want to delete ${s.name}?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: Colors.red))),
                    EditButton(text: 'Confirm', onPressed: (){
                      Navigator.pop(context);
                      ref.read(shareholderNotifierProvider.notifier).deleteShareholder(s.id);
                      ref.read(shareholderNotifierProvider.notifier).fetchShareholders();
                      ref.read(managementNotifierProvider.notifier).fetchAll();
                      showCustomSnackBar(context, message: 'Shareholder Removed!', isSuccess: true, title: 'Success!');
                    })
                  ],
                ),
              );
            },
            icon: Icon(Icons.delete, color: Colors.red),
          )
        ]))
      ]);
    }).toList(),
  );
}