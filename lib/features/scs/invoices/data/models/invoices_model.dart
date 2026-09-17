class InvoiceResponse {
  final String invoiceId;
  final String requestId;
  final double totalValue;
  final double outstandingValue;
  final String status;
  final DateTime dueAt;
  final DateTime createdAt;

  const InvoiceResponse({
    required this.invoiceId,
    required this.requestId,
    required this.totalValue,
    required this.outstandingValue,
    required this.status,
    required this.dueAt,
    required this.createdAt,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> map) {
    return InvoiceResponse(
      invoiceId: map["invoice_id"] ?? "",
      requestId: map["request_id"] ?? "",
      totalValue: (map["total_value"] as num?)?.toDouble() ?? 0,
      outstandingValue: (map["outstanding_value"] as num?)?.toDouble() ?? 0,
      status: map["status"] ?? "",
      dueAt: DateTime.tryParse(map["due_at"] ?? "") ?? DateTime.now(),
      createdAt: DateTime.tryParse(map["created_at"] ?? "") ?? DateTime.now(),
    );
  }
}

class ReceiptResponse {
  final String receiptId;
  final String invoiceId;
  final double amountPaid;
  final DateTime paidAt;

  const ReceiptResponse({
    required this.receiptId,
    required this.invoiceId,
    required this.amountPaid,
    required this.paidAt,
  });

  factory ReceiptResponse.fromJson(Map<String, dynamic> map) {
    return ReceiptResponse(
      receiptId: map["receipt_id"] ?? "",
      invoiceId: map["invoice_id"] ?? "",
      amountPaid: (map["amount_paid"] as num?)?.toDouble() ?? 0,
      paidAt: DateTime.tryParse(map["paid_at"] ?? "") ?? DateTime.now(),
    );
  }
}