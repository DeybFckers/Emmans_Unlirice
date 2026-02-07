class orderListModel {
  final int? OrderId;
  final int? ProductId;
  final int? ItemId;
  final String CustomerName;
  final String ProductName;
  final int Quantity;
  final double SubTotal;
  final double TotalAmount;
  final double AmountGiven;
  final double OrderChange;
  final String OrderType;
  final String PaymentMethod;
  String OrderStatus;
  final String Date;
  final int Discounted;
  final String ProductImage;

  orderListModel ({
    this.OrderId,
    this.ProductId,
    this.ItemId,
    required this.CustomerName,
    required this.ProductName,
    required this.Quantity,
    required this.SubTotal,
    required this.TotalAmount,
    required this.AmountGiven,
    required this.OrderChange,
    required this.OrderType,
    required this.PaymentMethod,
    required this.OrderStatus,
    required this.Date,
    required this.Discounted,
    required this.ProductImage,
  });

  factory orderListModel.fromMap(Map<String, dynamic> map){
    return orderListModel(
      OrderId: map['orderId'] as int?,
      ProductId: map['productId'] as int?,
      ItemId: map['itemId'] as int?,
      CustomerName: map['customerName'] as String? ?? '',
      ProductName: map['productName'] as String? ?? '',
      Quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      SubTotal: (map['subTotal'] as num?)?.toDouble() ?? 0.0,
      TotalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      AmountGiven: (map['amountGiven'] as num?)?.toDouble() ?? 0.0,
      OrderChange: (map['change'] as num?)?.toDouble() ?? 0.0,
      OrderType: map['orderType'] as String? ?? 'Dine In',
      PaymentMethod: map['paymentMethod'] as String? ?? 'Cash',
      OrderStatus: map['status'] as String? ?? 'In Progress',
      Date: map['date'] as String? ?? '',
      Discounted: (map['discount'] as num?)?.toInt() ?? 0,
      ProductImage: map['productImage'] as String? ?? '',
    );
  }

}