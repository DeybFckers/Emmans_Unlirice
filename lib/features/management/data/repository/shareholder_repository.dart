import 'package:coffee_pos/core/database/database_service.dart';
import 'package:coffee_pos/core/database/shareholder_table.dart';
import 'package:coffee_pos/features/management/data/models/shareholder_model.dart';

class ShareholderRepository {
  final StreetSideDatabase _database = StreetSideDatabase.instance;

  Future<void> addShareholder(ShareholderModel sh) async {
    try {
      final db = await _database.database;
      await db.insert(ShareholderTable.ShareholderTableName, {
        ShareholderTable.ShareholderName: sh.name,
        ShareholderTable.ShareholderPercentage: sh.percentage,
      });
    } catch (e) {
      print('Error adding shareholder: $e');
    }
  }

  Future<List<ShareholderModel>> getShareholders() async {
    try {
      final db = await _database.database;
      final data = await db.query(ShareholderTable.ShareholderTableName);
      return data.map((e) => ShareholderModel.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching shareholders: $e');
      return [];
    }
  }

  Future<void> updateShareholder(int id, String name, double percentage) async {
    try {
      final db = await _database.database;
      await db.update(
        ShareholderTable.ShareholderTableName,
        {
          ShareholderTable.ShareholderName: name,
          ShareholderTable.ShareholderPercentage: percentage,
        },
        where: '${ShareholderTable.ShareholderID} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error updating shareholder: $e');
    }
  }

  Future<void> deleteShareholder(int id) async {
    try {
      final db = await _database.database;
      await db.delete(
        ShareholderTable.ShareholderTableName,
        where: '${ShareholderTable.ShareholderID} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting shareholder: $e');
    }
  }
}
