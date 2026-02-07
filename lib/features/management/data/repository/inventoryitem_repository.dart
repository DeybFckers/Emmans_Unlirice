import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/core/database/inventoryitem_table.dart';
import 'package:coffee_pos/features/management/data/models/InventoryItem_model.dart';

class InventoryitemRepository {
  final StreetSideDatabase _database = StreetSideDatabase.instance;

  Future<void> addInventoryItem(InventoryItemModel inventoryitem) async{
    try {
      final db = await _database.database;
      await db.insert(InventoryItemTable.InventoryItemTableName, {
        InventoryItemTable.InventoryItemName: inventoryitem.name,
        InventoryItemTable.InventoryItemCost: inventoryitem.cost,
        InventoryItemTable.InventoryItemDate: inventoryitem.date,
      });
    }catch(e){
      print('Error Adding Item: $e');
    }
  }

  Future<List<InventoryItemModel>> getInventoryItem() async{
    try{
      final db = await _database.database;
      final data = await db.query(InventoryItemTable.InventoryItemTableName);
      return data.map((e) => InventoryItemModel.fromMap(e)).toList();
    }catch(e){
      print('Error getting product: $e');
      return [];
    }
  }

  Future<void> updateInventoryItem(int id, String name, double cost) async {
    try {
      final db = await _database.database;
      await db.update(
        InventoryItemTable.InventoryItemTableName,
        {
          InventoryItemTable.InventoryItemName: name,
          InventoryItemTable.InventoryItemCost: cost,
        },
        where: '${InventoryItemTable.InventoryItemID} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error updating inventory item: $e');
    }
  }

  Future<void> deleteInventoryItem(int id) async {
    try {
      final db = await _database.database;
      await db.delete(
        InventoryItemTable.InventoryItemTableName,
        where: '${InventoryItemTable.InventoryItemID} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting inventory item: $e');
    }
  }
}