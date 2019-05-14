part of firestore_api;

abstract class TeslaApiEndpoints {
  factory TeslaApiEndpoints.standard() {
    return new TeslaStandardApiEndpoints();
  }

  Uri get ownersApiUrl;
  Uri get summonConnectUrl;
  String get clientId;
  String get clientSecret;
  bool get enableProxyMode;
}

class TeslaStandardApiEndpoints implements TeslaApiEndpoints {
  @override
  final Uri ownersApiUrl = Uri.parse("https://owner-api.teslamotors.com/");

  @override
  final Uri summonConnectUrl =
      Uri.parse("wss://streaming.vn.teslamotors.com/connect/");

  @override
  final String clientId =
      "81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384";

  @override
  final String clientSecret =
      "c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3";

  @override
  bool get enableProxyMode => false;
}
