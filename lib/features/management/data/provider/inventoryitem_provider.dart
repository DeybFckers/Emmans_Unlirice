import 'package:coffee_pos/features/management/data/models/InventoryItem_model.dart';
import 'package:coffee_pos/features/management/data/repository/inventoryitem_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class InventoryitemNotifier extends StateNotifier<AsyncValue<List<InventoryItemModel>>>{
  final InventoryitemRepository _inventoryitemRepository;

  InventoryitemNotifier(this._inventoryitemRepository): super(const AsyncValue.loading()){
    fetchInventoryItem();
  }

  Future<void> fetchInventoryItem() async{
    try{
      final inventory = await _inventoryitemRepository.getInventoryItem();

      state = AsyncValue.data(inventory);
    }catch(e, st){
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addInventoryItem(InventoryItemModel inventoryitem) async{

    await _inventoryitemRepository.addInventoryItem(inventoryitem);

    await fetchInventoryItem();
  }

  Future<void> updateInventoryItem(int id, String name, double cost) async {
    await _inventoryitemRepository.updateInventoryItem(id, name, cost);
    await fetchInventoryItem();
  }

  Future<void> deleteInventoryItem(int id) async {
    await _inventoryitemRepository.deleteInventoryItem(id);
    await fetchInventoryItem();
  }
}

final inventoryitemRepositoryProvider = Provider<InventoryitemRepository>((ref){
  return InventoryitemRepository();
});

final inventoryitemNotifierProvider = StateNotifierProvider<InventoryitemNotifier, AsyncValue<List<InventoryItemModel>>>((ref){
  final repository = ref.read(inventoryitemRepositoryProvider);

  return InventoryitemNotifier(repository);
});