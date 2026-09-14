class AppTokens {
  String accessToken;

  AppTokens({
    this.accessToken = "",
  });
}

class UserCredentials {
  String sellerid;

  UserCredentials({
    this.sellerid = "",
  });
}

class UserLocation {
  double latitude;
  double longitude;

  UserLocation({
    this.latitude = 0,
    this.longitude = 0,
  });
}
