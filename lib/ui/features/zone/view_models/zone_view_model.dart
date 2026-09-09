import 'package:flutter/foundation.dart';
import 'package:flutter_proyect/data/repositories/table_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';

class ZoneViewModel extends ChangeNotifier {
  ZoneViewModel(this._tableRepository);

  final TableRepository _tableRepository;

  /// Snap grid for table positions and the toolbar offset subtracted from the
  /// drag Y offset before snapping.
  static const double kGridX = 30;
  static const double kGridY = 100;
  static const double kHeaderOffsetY = 56;

  List<RestTable> _tables = [];
  bool _isLoading = false;
  bool _deleteMode = false;

  List<RestTable> get tables => List.unmodifiable(_tables);
  bool get isLoading => _isLoading;
  bool get deleteMode => _deleteMode;

  Future<void> loadTables() async {
    _isLoading = true;
    notifyListeners();
    try {
      _tables = await _tableRepository.getTables();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  RestTable snapPosition(RestTable table, double dx, double dy) {
    return table.copyWith(
      top: ((dy - kHeaderOffsetY) / kGridY).round() * kGridY,
      left: (dx / kGridX).round() * kGridX,
    );
  }

  Future<void> moveTable(RestTable table, double dx, double dy) async {
    await _tableRepository.updateTable(snapPosition(table, dx, dy));
    await loadTables();
  }

  Future<void> addTable(String number) async {
    await _tableRepository.addTable(number: number);
    await loadTables();
  }

  Future<void> deleteTable(int id) async {
    await _tableRepository.deleteTable(id);
    _deleteMode = false;
    await loadTables();
  }

  void toggleDeleteMode() {
    _deleteMode = !_deleteMode;
    notifyListeners();
  }
}