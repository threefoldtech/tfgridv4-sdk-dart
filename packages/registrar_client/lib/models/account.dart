import 'farm.dart';

class Account {
  final String createdAt;
  final List<Farm> farms;
  final String publicKey;
  final List<String> relays;
  final String rmbEncKey;
  final int twinID;
  final String updatedAt;

  Account({
    required this.createdAt,
    required this.farms,
    required this.publicKey,
    required this.relays,
    required this.rmbEncKey,
    required this.twinID,
    required this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      createdAt: json['created_at'],
      farms:
          (json['farms'] as List).map((farm) => Farm.fromJson(farm)).toList(),
      publicKey: json['public_key'],
      relays: json['relays'],
      rmbEncKey: json['rmb_enc_key'],
      twinID: json['twin_id'],
      updatedAt: json['updated_at'],
    );
  }
}

class AccountCreationRequest {
  final String publicKey;
  final String signature;
  final int timestamp;
  final List<String>? relays;
  final String? rmbEncKey;

  AccountCreationRequest({
    required this.publicKey,
    required this.signature,
    required this.timestamp,
    this.relays,
    this.rmbEncKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'public_key': publicKey,
      'signature': signature,
      'timestamp': timestamp,
      'relays': relays,
      'rmb_enc_key': rmbEncKey,
    };
  }
}

class AccountUpdateRequest {
  final List<String> relays;
  final String rmbEncKey;

  AccountUpdateRequest({
    required this.relays,
    required this.rmbEncKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'relays': relays,
      'rmb_enc_key': rmbEncKey,
    };
  }
}
