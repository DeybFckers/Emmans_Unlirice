import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/core/database/inventoryitem_table.dart';
import 'package:coffee_pos/core/database/order_table.dart';
import 'package:coffee_pos/core/database/product_table.dart';
import 'package:coffee_pos/features/management/data/models/shareholder_model.dart';
import 'package:coffee_pos/features/management/data/models/InventoryItem_model.dart';
import 'package:coffee_pos/features/management/data/models/orderlist_model.dart';
import 'package:coffee_pos/features/products/data/models/order_model.dart';
import 'package:coffee_pos/features/management/data/models/product_model.dart';

class ManagementRepository {
  final StreetSideDatabase _database = StreetSideDatabase.instance;

  Future<List<ProductModel>> getManagementProduct() async {
    try {
      final db = await _database.database;
      final data = await db.query(ProductTable.ProductTableName);
      return data.map((e) => ProductModel.fromMap(e)).toList();
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  Future<List<OrderModel>> getManagementOrder() async {
    try {
      final db = await _database.database;
      final data = await db.query(OrderTable.OrderTableName);
      return data.map((e) => OrderModel.fromMap(e)).toList();
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  Future<List<orderListModel>> getManagementOrderList() async {
    try {
      final db = await _database.database;
      final data = await db.query(OrderTable.ListTableName);
      return data.map((e) => orderListModel.fromMap(e)).toList();
    } catch (e) {
      print('Error getting order list: $e');
      return [];
    }
  }

  Future<List<InventoryItemModel>> getManagementInventoryItem() async {
    try {
      final db = await _database.database;
      final data = await db.query(InventoryItemTable.InventoryItemTableName);
      return data.map((e) => InventoryItemModel.fromMap(e)).toList();
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  Future<List<ShareholderModel>> getManagementShareholders() async {
    try {
      final db = await _database.database;
      final data = await db.query('Shareholder');
      return data.map((e) => ShareholderModel.fromMap(e)).toList();
    } catch (e) {
      print('Error getting shareholders: $e');
      return [];
    }
  }
}
