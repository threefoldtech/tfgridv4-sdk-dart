abstract class NodeBase {
  final int farmID;
  final List<Interface> interfaces;
  final Location location;
  final Resources resources;
  final bool? secureBoot;
  final String serialNumber;
  final bool? virtualized;

  NodeBase({
    required this.farmID,
    required this.interfaces,
    required this.location,
    required this.resources,
    this.secureBoot,
    required this.serialNumber,
    this.virtualized,
  }) {
    _validateSerialNumber(serialNumber);
  }

  void _validateSerialNumber(String serialNumber) {
    if (serialNumber.isEmpty) {
      throw ArgumentError('Serial number cannot be empty');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'farm_id': farmID,
      'Interfaces': interfaces.map((interface) => interface.toJson()).toList(),
      'location': location.toJson(),
      'resources': resources.toJson(),
      'secure_boot': secureBoot,
      'serial_number': serialNumber,
      'virtualized': virtualized,
    };
  }
}

class Node extends NodeBase {
  final bool approved;
  final String createdAt;
  final int nodeID;
  final int twinID;
  final String updatedAt;
  final List<UptimeReport> uptime;

  Node({
    required this.approved,
    required this.createdAt,
    required this.nodeID,
    required this.twinID,
    required this.updatedAt,
    required this.uptime,
    required int farmID,
    required List<Interface> interfaces,
    required Location location,
    required Resources resources,
    bool? secureBoot,
    required String serialNumber,
    bool? virtualized,
  }) : super(
          farmID: farmID,
          interfaces: interfaces,
          location: location,
          resources: resources,
          secureBoot: secureBoot,
          serialNumber: serialNumber,
          virtualized: virtualized,
        );

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      farmID: json['farm_id'],
      interfaces: (json['Interfaces'] as List)
          .map((interface) => Interface.fromJson(interface))
          .toList(),
      location: Location.fromJson(json['location']),
      resources: Resources.fromJson(json['resources']),
      secureBoot: json['secure_boot'],
      serialNumber: json['serial_number'],
      virtualized: json['virtualized'],
      approved: json['approved'],
      createdAt: json['created_at'],
      nodeID: json['node_id'],
      twinID: json['twin_id'],
      updatedAt: json['updated_at'],
      uptime: json['uptime'] != null
          ? (json['uptime'] as List)
              .map((uptime) => UptimeReport.fromJson(uptime))
              .toList()
          : [],
    );
  }
}

class Interface {
  final String ips;
  final String mac;
  final String name;

  Interface({
    required this.ips,
    required this.mac,
    required this.name,
  });

  factory Interface.fromJson(Map<String, dynamic> json) {
    return Interface(
      ips: json['ips'],
      mac: json['mac'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ips': ips,
      'mac': mac,
      'name': name,
    };
  }
}

class Location {
  final String city;
  final String country;
  final String latitude;
  final String longitude;

  Location({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'],
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class Resources {
  final int cru;
  final int hru;
  final int mru;
  final int sru;

  Resources({
    required this.cru,
    required this.hru,
    required this.mru,
    required this.sru,
  });

  factory Resources.fromJson(Map<String, dynamic> json) {
    return Resources(
      cru: json['cru'],
      hru: json['hru'],
      mru: json['mru'],
      sru: json['sru'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cru': cru,
      'hru': hru,
      'mru': mru,
      'sru': sru,
    };
  }
}

class UptimeReport {
  final String createdAt;
  final int duration;
  final int nodeID;
  final String timestamp;
  final bool wasRestarted;

  UptimeReport({
    required this.createdAt,
    required this.duration,
    required this.nodeID,
    required this.timestamp,
    required this.wasRestarted,
  });

  factory UptimeReport.fromJson(Map<String, dynamic> json) {
    return UptimeReport(
      createdAt: json['created_at'],
      duration: json['duration'],
      nodeID: json['node_id'],
      timestamp: json['timestamp'],
      wasRestarted: json['was_restarted'],
    );
  }
}

class NodeRegistrationRequest extends NodeBase {
  final int twinID;
  NodeRegistrationRequest({
    required this.twinID,
    required int farmID,
    required List<Interface> interfaces,
    required Location location,
    required Resources resources,
    bool? secureBoot,
    required String serialNumber,
    bool? virtualized,
  }) : super(
          farmID: farmID,
          interfaces: interfaces,
          location: location,
          resources: resources,
          secureBoot: secureBoot,
          serialNumber: serialNumber,
          virtualized: virtualized,
        );

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'twin_id': twinID,
    };
  }
}

class UpdateNodeRequest extends NodeBase {
  UpdateNodeRequest({
    required int farmID,
    required List<Interface> interfaces,
    required Location location,
    required Resources resources,
    bool? secureBoot,
    required String serialNumber,
    bool? virtualized,
  }) : super(
          farmID: farmID,
          interfaces: interfaces,
          location: location,
          resources: resources,
          secureBoot: secureBoot,
          serialNumber: serialNumber,
          virtualized: virtualized,
        );

  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}

class NodeFilter {
  final int? farmID;
  final int? nodeID;
  final int? twinID;
  final String? status;
  final bool? healthy;
  final int? page;
  final int? size;

  NodeFilter({
    this.farmID,
    this.nodeID,
    this.twinID,
    this.status,
    this.healthy,
    this.page,
    this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'farm_id': farmID,
      'node_id': nodeID,
      'twin_id': twinID,
      'status': status,
      'healthy': healthy,
      'page': page,
      'size': size,
    };
  }
}

class ReportUptimeRequest {
  final Duration uptime;
  final DateTime timestamp;

  ReportUptimeRequest({
    required Duration this.uptime,
    required DateTime this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'uptime': uptime.inSeconds,
      'timestamp': timestamp.toUtc().toIso8601String(),
    };
  }
}
