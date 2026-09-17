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

  const CreatePickupRequestPayload({
    required this.distributorId,
    required this.products,
  });

  Map<String, dynamic> toJson() {
    return {"distributor_id": distributorId, "products": products};
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