import 'package:coffee_pos/features/management/data/models/shareholder_model.dart';
import 'package:coffee_pos/features/management/data/repository/shareholder_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class ShareholderNotifier extends StateNotifier<AsyncValue<List<ShareholderModel>>> {
  final ShareholderRepository _repository;

  ShareholderNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchShareholders();
  }

  Future<void> fetchShareholders() async {
    try {
      final data = await _repository.getShareholders();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addShareholder(ShareholderModel sh) async {
    await _repository.addShareholder(sh);
    await fetchShareholders();
  }

  Future<void> updateShareholder(int id, String name, double percentage) async {
    await _repository.updateShareholder(id, name, percentage);
    await fetchShareholders();
  }

  Future<void> deleteShareholder(int id) async {
    await _repository.deleteShareholder(id);
    await fetchShareholders();
  }
}

final shareholderRepositoryProvider = Provider<ShareholderRepository>((ref) {
  return ShareholderRepository();
});

final shareholderNotifierProvider = StateNotifierProvider<ShareholderNotifier, AsyncValue<List<ShareholderModel>>>((ref) {
  final repo = ref.read(shareholderRepositoryProvider);
  return ShareholderNotifier(repo);
});
