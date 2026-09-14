class SalesSession {
  String userId;
  String role;
  bool verified;
  String token;

  SalesSession({
    this.userId = "",
    this.role = "",
    this.verified = false,
    this.token = "",
  });

  bool get isLoggedIn => userId.isNotEmpty && token.isNotEmpty;

  void clear() {
    userId = "";
    role = "";
    verified = false;
    token = "";
  }
}