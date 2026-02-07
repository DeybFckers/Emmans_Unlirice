class InventoryItemModel {
  final int id;
  final String name;
  final double cost;
  final String date;

  InventoryItemModel({
    required this.id,
    required this.name,
    required this.cost,
    required this.date,
  });

  factory InventoryItemModel.fromMap(Map<String, dynamic>map){
    return InventoryItemModel(
      id: map['InventoryItem_Id'] as int, 
      name: map['InventoryItem_Name'] as String, 
      cost: (map['InventoryItem_Cost']as num).toDouble(), 
      date: map['InventoryItem_Date'] as String,
    );
  }
}