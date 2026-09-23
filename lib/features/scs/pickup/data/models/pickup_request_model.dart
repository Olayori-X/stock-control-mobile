class DistributorSearchResponse {
  final String userId;
  final String name;
  final String email;
  final String phone;

  const DistributorSearchResponse({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory DistributorSearchResponse.fromJson(Map<String, dynamic> map) {
    return DistributorSearchResponse(
      userId: map["user_id"] ?? "",
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      phone: map["phone"] ?? "",
    );
  }
}

class SearchDistributorsResponse {
  final List<DistributorSearchResponse> users;
  final int total;

  const SearchDistributorsResponse({required this.users, required this.total});

  factory SearchDistributorsResponse.fromJson(Map<String, dynamic> map) {
    return SearchDistributorsResponse(
      users: ((map["users"] as List?) ?? [])
          .map((u) => DistributorSearchResponse.fromJson(u as Map<String, dynamic>))
          .toList(),
      total: map["total"] ?? 0,
    );
  }
}

class CreatePickupRequestPayload {
  final String distributorId;
  final List<Map<String, dynamic>> products;
  final String? sessionId;

  const CreatePickupRequestPayload({
    required this.distributorId,
    required this.products,
    this.sessionId,
  });

  Map<String, dynamic> toJson() {
    return {"distributor_id": distributorId, "products": products, "sales_associate_id": sessionId};
  }
}

class PickupRequestResponse {
  final String requestId;
  final bool confirmed;
  final DateTime createdAt;

  const PickupRequestResponse({
    required this.requestId,
    required this.confirmed,
    required this.createdAt,
  });

  factory PickupRequestResponse.fromJson(Map<String, dynamic> map) {
    return PickupRequestResponse(
      requestId: map["request_id"] ?? "",
      confirmed: map["confirmed"] ?? false,
      createdAt: DateTime.tryParse(map["created_at"] ?? "") ?? DateTime.now(),
    );
  }
}

class ProductResponse {
  final String sku;
  final String name;

  const ProductResponse({required this.sku, required this.name});

  factory ProductResponse.fromJson(Map<String, dynamic> map) {
    return ProductResponse(sku: map["sku"] ?? "", name: map["name"] ?? "");
  }
}

// The backend's GetMyPickupRequests joins on distributor_id and scans
// into a field literally named sales_associate_name (models.PendingPickupRequest
// is reused across several endpoints with different join targets — same
// quirk already documented for the unacceptedrequests/pendingrequests
// pair on the web dashboard). Here, that field holds the distributor's
// name, not the sales associate's — handled explicitly below rather than
// left as a landmine for whoever reads this next.
class ProductItemResponse {
  final String sku;
  final String name;
  final int quantity;

  const ProductItemResponse({required this.sku, required this.name, required this.quantity});

  factory ProductItemResponse.fromJson(Map<String, dynamic> map) {
    return ProductItemResponse(
      sku: map["sku"] ?? "",
      name: map["name"] ?? "",
      quantity: map["quantity"] ?? 0,
    );
  }
}

class MyPickupRequestResponse {
  final String requestId;
  final String distributorId;
  final String distributorName; // from the misleadingly-named sales_associate_name JSON field
  final bool confirmed;
  final List<ProductItemResponse> products;
  final DateTime createdAt;

  const MyPickupRequestResponse({
    required this.requestId,
    required this.distributorId,
    required this.distributorName,
    required this.confirmed,
    required this.products,
    required this.createdAt,
  });

  factory MyPickupRequestResponse.fromJson(Map<String, dynamic> map) {
    return MyPickupRequestResponse(
      requestId: map["request_id"] ?? "",
      distributorId: map["distributor_id"] ?? "",
      distributorName: map["sales_associate_name"] ?? "",
      confirmed: map["confirmed"] ?? false,
      products: ((map["products"] as List?) ?? [])
          .map((p) => ProductItemResponse.fromJson(p as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.tryParse(map["created_at"] ?? "") ?? DateTime.now(),
    );
  }
}