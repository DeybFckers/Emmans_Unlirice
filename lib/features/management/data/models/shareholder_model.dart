class ShareholderModel {
  final int id;
  final String name;
  final double percentage;

  ShareholderModel({
    required this.id,
    required this.name,
    required this.percentage,
  });

  factory ShareholderModel.fromMap(Map<String, dynamic> map){
    return ShareholderModel(
      id: map['Shareholder_Id'] as int, 
      name: map['Shareholder_Name'] as String, 
      percentage: (map['Shareholder_Percentage'] as num).toDouble()
    );
  }
}