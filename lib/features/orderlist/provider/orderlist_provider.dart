import 'package:coffee_pos/features/orderlist/data/orderlist_repository.dart';
import 'package:coffee_pos/features/orderlist/models/orderlist_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class OrderlistNotifier extends StateNotifier<AsyncValue<Map<int, List<orderListModel>>>> {
  final OrderlistRepository _orderListRepository;

  OrderlistNotifier(this._orderListRepository) : super(AsyncValue.loading()) {
    fetchOrderList();
  }

  Future<void> fetchOrderList() async {
    try {
      final groupedOrders = await _orderListRepository.getGroupedOrders();
      state = AsyncValue.data(groupedOrders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final orderListRepositoryProvider = Provider<OrderlistRepository>((ref) {
  return OrderlistRepository();
});

final orderListNotifierProvider = StateNotifierProvider<
    OrderlistNotifier, AsyncValue<Map<int, List<orderListModel>>>>(
      (ref) {
    final repository = ref.read(orderListRepositoryProvider);
    return OrderlistNotifier(repository);
  },
);
