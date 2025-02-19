import 'node.dart';

class Farm {
  final String? createdAt;
  final bool dedicated;
  final int? farmID;
  final String farmName;
  final List<Node>? nodes;
  final int twinID;
  final String? updatedAt;

  Farm({
    this.createdAt,
    required this.dedicated,
    this.farmID,
    required farmName,
    this.nodes,
    required twinID,
    this.updatedAt,
  })  : farmName = _validateFarmName(farmName),
        twinID = _validateTwinId(twinID);

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      createdAt: json['created_at'],
      dedicated: json['dedicated'],
      farmID: json['farm_id'],
      farmName: json['farm_name'],
      nodes: json['nodes'] != null
          ? (json['nodes'] as List).map((node) => Node.fromJson(node)).toList()
          : null,
      twinID: json['twin_id'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt,
      'dedicated': dedicated,
      'farm_id': farmID,
      'farm_name': farmName,
      'nodes': nodes??[],
      'twin_id': twinID,
      'updated_at': updatedAt,
    };
  }

  static String _validateFarmName(String farmName) {
    if (farmName.isEmpty) {
      throw ArgumentError('Farm name cannot be empty');
    }
    return farmName;
  }

  static int _validateTwinId(int twinId) {
    if (twinId < 0) {
      throw ArgumentError('Twin ID cannot be negative');
    }
    return twinId;
  }
}

class FarmFilter {
  final String? farmName;
  final int? twinID;
  final int? farmID;
  final int? page;
  final int? size;

  FarmFilter({
    this.farmName,
    this.twinID,
    this.farmID,
    this.page,
    this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'farm_name': farmName,
      'twin_id': twinID,
      'farm_id': farmID,
      'page': page,
      'size': size,
    };
  }
}
