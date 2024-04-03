import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Credential {
  final String type;
  final String projectId;
  final String privateKeyId;
  final String privateKey;
  final String clientEmail;
  final String clientId;
  final String authUri;
  final String tokenUri;
  final String authProviderX509CertUrl;
  final String clientX509CertUrl;
  final String universeDomain;

  Credential({
    required this.type,
    required this.projectId,
    required this.privateKeyId,
    required this.privateKey,
    required this.clientEmail,
    required this.clientId,
    required this.authUri,
    required this.tokenUri,
    required this.authProviderX509CertUrl,
    required this.clientX509CertUrl,
    required this.universeDomain,
  });

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(
      type: json['type'],
      projectId: json['project_id'],
      privateKeyId: json['private_key_id'],
      privateKey: json['private_key'],
      clientEmail: json['client_email'],
      clientId: json['client_id'],
      authUri: json['auth_uri'],
      tokenUri: json['token_uri'],
      authProviderX509CertUrl: json['auth_provider_x509_cert_url'],
      clientX509CertUrl: json['client_x509_cert_url'],
      universeDomain: json['universe_domain'],
    );
  }
}

class JsonReader {
  Future<Credential> readCredentials() async {
    String jsonString = await rootBundle.loadString('assets/credentials.json');
    Map<String, dynamic> jsonData = json.decode(jsonString);
    return Credential.fromJson(jsonData);
  }
}