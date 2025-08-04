class BillSummaryItem {
  final double basePricePerItem;
  final double gstPerItem;
  final double baseTotal;
  final double gstTotal;
  final double totalWithGst;
  final int quantity;

  BillSummaryItem({
    required this.basePricePerItem,
    required this.gstPerItem,
    required this.baseTotal,
    required this.gstTotal,
    required this.totalWithGst,
    required this.quantity,
  });
}
