import 'package:coffee_pos/core/database/analytics_table.dart';
import 'package:coffee_pos/core/database/inventoryitem_table.dart';
import 'package:coffee_pos/core/database/order_table.dart';
import 'package:coffee_pos/core/database/product_table.dart';
import 'package:coffee_pos/core/database/shareholder_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StreetSideDatabase {
  static Database? _db;
  static final StreetSideDatabase instance = StreetSideDatabase._internal();

  StreetSideDatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "streetside_db.db");
    // await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Product table
        await db.execute('''
        CREATE TABLE ${ProductTable.ProductTableName}(
          ${ProductTable.ProductID} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${ProductTable.ProductName} TEXT,
          ${ProductTable.ProductCategory} TEXT CHECK (${ProductTable.ProductCategory} IN ('Coffee', 'Food', 'Drinks', 'Short Order')) NOT NULL,
          ${ProductTable.ProductPrice} REAL NOT NULL,
          ${ProductTable.ProductCost} REAL NOT NULL,
          ${ProductTable.ProductImage} TEXT
        )
        ''');

        // Shareholder table
        await db.execute('''
        CREATE TABLE ${ShareholderTable.ShareholderTableName}(
          ${ShareholderTable.ShareholderID} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${ShareholderTable.ShareholderName} TEXT,
          ${ShareholderTable.ShareholderPercentage} REAL NOT NULL
        )
        ''');

        // Item table (expenses)
        await db.execute('''
        CREATE TABLE ${InventoryItemTable.InventoryItemTableName}(
          ${InventoryItemTable.InventoryItemID} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${InventoryItemTable.InventoryItemName} TEXT,
          ${InventoryItemTable.InventoryItemCost} REAL NOT NULL,
          ${InventoryItemTable.InventoryItemDate} TEXT DEFAULT CURRENT_TIMESTAMP
        )
        ''');

        // Order table
        await db.execute('''
        CREATE TABLE ${OrderTable.OrderTableName}(
          ${OrderTable.OrderID} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${OrderTable.OrderCustomer} TEXT,
          ${OrderTable.OrderTotalAmount} REAL NOT NULL,
          ${OrderTable.OrderAmountGiven} REAL,
          ${OrderTable.OrderChange} REAL,
          ${OrderTable.OrderType} TEXT CHECK (${OrderTable.OrderType} IN ('Dine In', 'Take Out', 'Delivery')) NOT NULL,
          ${OrderTable.OrderPayment} TEXT CHECK (${OrderTable.OrderPayment} IN ('Cash', 'Gcash')) NOT NULL,
          ${OrderTable.OrderStatus} TEXT CHECK (${OrderTable.OrderStatus} IN ('In Progress', 'Completed', 'Refund')) NOT NULL DEFAULT 'In Progress',
          ${OrderTable.OrderDiscount} INTEGER NOT NULL DEFAULT 0,
          ${OrderTable.OrderCreatedAT} TEXT DEFAULT CURRENT_TIMESTAMP
        )
        ''');

        // Order items table
        await db.execute('''
        CREATE TABLE ${OrderTable.ItemTableName}(
          ${OrderTable.ItemID} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${OrderTable.ItemOrder} INTEGER NOT NULL,
          ${OrderTable.ItemProduct} INTEGER NOT NULL,
          ${OrderTable.ItemQuantity} INTEGER NOT NULL,
          ${OrderTable.ItemSubtotal} REAL NOT NULL,
          FOREIGN KEY (${OrderTable.ItemOrder}) REFERENCES ${OrderTable.OrderTableName}(${OrderTable.OrderID}),
          FOREIGN KEY (${OrderTable.ItemProduct}) REFERENCES ${ProductTable.ProductTableName}(${ProductTable.ProductID})
        )
        ''');

        // Order list view
        await db.execute('''
        CREATE VIEW IF NOT EXISTS ${OrderTable.ListTableName} AS
        SELECT 
          o.${OrderTable.OrderID} AS orderId,
          o.${OrderTable.OrderCustomer} AS customerName,
          o.${OrderTable.OrderTotalAmount} AS totalAmount,
          o.${OrderTable.OrderAmountGiven} AS amountGiven,
          o.${OrderTable.OrderChange} AS change,
          o.${OrderTable.OrderType} AS orderType,
          o.${OrderTable.OrderPayment} AS paymentMethod,
          o.${OrderTable.OrderStatus} AS status,
          o.${OrderTable.OrderDiscount} AS discount,
          o.${OrderTable.OrderCreatedAT} AS date,
          p.${ProductTable.ProductID} AS productId,
          p.${ProductTable.ProductName} AS productName,
          p.${ProductTable.ProductImage} AS productImage,
          i.${OrderTable.ItemID} AS itemId,
          i.${OrderTable.ItemQuantity} AS quantity,
          i.${OrderTable.ItemSubtotal} AS subTotal
        FROM ${OrderTable.OrderTableName} o
        JOIN ${OrderTable.ItemTableName} i
          ON o.${OrderTable.OrderID} = i.${OrderTable.ItemOrder}
        JOIN ${ProductTable.ProductTableName} p
          ON i.${OrderTable.ItemProduct} = p.${ProductTable.ProductID};
        ''');

        _createViews(db);
      },
    );
  }

  void _createViews(Database db) {
    db.execute('''
    CREATE VIEW IF NOT EXISTS ${AnalyticsTable.MonthlySalesTableName} AS
    SELECT 
      strftime('%Y-%m', ${OrderTable.OrderCreatedAT}) AS Month,
      SUM(${OrderTable.OrderTotalAmount}) AS Total_Sales,
      COUNT(${OrderTable.OrderID}) AS Total_Orders
    FROM ${OrderTable.OrderTableName}
    WHERE ${OrderTable.OrderStatus} = 'Completed'
    GROUP BY Month
    ORDER BY Month DESC;
    ''');

    db.execute('''
    CREATE VIEW IF NOT EXISTS ${AnalyticsTable.MonthlyPaymentTableName} AS
    SELECT
      strftime('%Y-%m', ${OrderTable.OrderCreatedAT}) AS Month,
      SUM(CASE WHEN ${OrderTable.OrderPayment} = 'Cash' THEN ${OrderTable.OrderTotalAmount} ELSE 0 END) AS Total_Cash,
      SUM(CASE WHEN ${OrderTable.OrderPayment} = 'Gcash' THEN ${OrderTable.OrderTotalAmount} ELSE 0 END) AS Total_Gcash
    FROM ${OrderTable.OrderTableName}
    WHERE ${OrderTable.OrderStatus} = 'Completed'
    GROUP BY Month
    ORDER BY Month DESC;
    ''');

    db.execute('''
    CREATE VIEW IF NOT EXISTS ${AnalyticsTable.MonthlyCOGSTableName} AS
    SELECT 
      strftime('%Y-%m', o.${OrderTable.OrderCreatedAT}) AS Month,
      SUM(oi.${OrderTable.ItemQuantity} * p.${ProductTable.ProductCost}) AS Total_Product_Cost
    FROM ${OrderTable.OrderTableName} o
    JOIN ${OrderTable.ItemTableName} oi ON o.${OrderTable.OrderID} = oi.${OrderTable.ItemOrder}
    JOIN ${ProductTable.ProductTableName} p ON oi.${OrderTable.ItemProduct} = p.${ProductTable.ProductID}
    WHERE o.${OrderTable.OrderStatus} = 'Completed'
    GROUP BY Month
    ORDER BY Month DESC;
    ''');

    db.execute('''
    CREATE VIEW IF NOT EXISTS ${AnalyticsTable.MonthlyItemExpensesTableName} AS
    SELECT 
      strftime('%Y-%m', ${InventoryItemTable.InventoryItemDate}) AS Month,
      SUM(${InventoryItemTable.InventoryItemCost}) AS Total_Item_Expenses
    FROM ${InventoryItemTable.InventoryItemTableName}
    GROUP BY Month
    ORDER BY Month DESC;
    ''');

    db.execute('''
    CREATE VIEW IF NOT EXISTS ${AnalyticsTable.MonthlyProfitTableName} AS
    SELECT 
      s.Month,
      s.Total_Sales AS Revenue,
      COALESCE(c.Total_Product_Cost, 0) AS Product_Costs,
      COALESCE(e.Total_Item_Expenses, 0) AS Item_Expenses,
      (s.Total_Sales - COALESCE(c.Total_Product_Cost, 0) - COALESCE(e.Total_Item_Expenses, 0)) AS Net_Profit
    FROM ${AnalyticsTable.MonthlySalesTableName} s
    LEFT JOIN ${AnalyticsTable.MonthlyCOGSTableName} c ON s.Month = c.Month
    LEFT JOIN ${AnalyticsTable.MonthlyItemExpensesTableName} e ON s.Month = e.Month
    ORDER BY s.Month DESC;
    ''');
  }
}
