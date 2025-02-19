
import 'package:registrar_client/registrar_client.dart';
import 'package:test/test.dart';
import 'package:pinenacl/ed25519.dart';
import 'dart:convert';

void main() async {
  group('Test Nodes', () {
    final privateKey = SigningKey.generate().seed;
    final client = RegistrarClient(
        baseUrl: 'http://registrar/v1',
        privateKey: base64Encode(privateKey));
    int twinID = 0;
    int farmID = 0;
    int nodeID = 0;
    test('Register node', () async {
      final account = await client.accounts.create();
      twinID = account.twinID;

      final farmName = '${DateTime.now()} - farm';
      final farmIDCreated = await client.farms.create(
          Farm(dedicated: true, farmName: farmName, nodes: [], twinID: twinID));
      expect(farmID, isNotNull);
      expect(farmID, isA<int>());
      farmID = farmIDCreated;

      final node = NodeRegistrationRequest(
        twinID: twinID,
        farmID: farmID,
        interfaces: [
          Interface(
            name: 'eth0',
            mac: '00:11:22:33:44:55',
            ip: '192.168.1.100',
          ),
          Interface(
            name: 'wlan0',
            mac: '66:77:88:99:AA:BB',
            ip: '192.168.1.101',
          ),
        ],
        location: Location(
          country: 'USA',
          city: 'New York',
          latitude: '40.7128',
          longitude: '-74.0060',
        ),
        resources: Resources(
          cru: 8,
          hru: 2000,
          mru: 16384,
          sru: 500,
        ),
        secureBoot: true,
        serialNumber: 'SN-987654321',
        virtualized: false,
      );

      final nodeIDCreated = await client.nodes.create(node);
      expect(nodeIDCreated, isNotNull);
      expect(nodeIDCreated, isA<int>());
      nodeID = nodeIDCreated;
    });

    test('Get node', () async {
      final node = await client.nodes.get(nodeID);
      expect(node, isNotNull);
      expect(node.nodeID, nodeID);
    });

    test('List nodes', () async {
      final nodes = await client.nodes.list(NodeFilter(twinID: twinID));
      expect(nodes, isNotNull);
      expect(nodes, isA<List<Node>>());
      expect(nodes.length, greaterThan(0));

      final nodesByFarm = await client.nodes.list(NodeFilter(farmID: farmID));
      expect(nodesByFarm, isNotNull);
      expect(nodesByFarm, isA<List<Node>>());
      expect(nodesByFarm.length, greaterThan(0));
    });

    test('Update node', () async {
      final node = UpdateNodeRequest(
        farmID: farmID,
        interfaces: [],
        location: Location(
          country: 'Korea',
          city: 'Seoul',
          latitude: '37.5665',
          longitude: '126.9780',
        ),
        resources: Resources(
          cru: 16,
          hru: 4000,
          mru: 32768,
          sru: 1000,
        ),
        secureBoot: false,
        serialNumber: 'SN-123456789',
        virtualized: true,
      );

      final updatedNode = await client.nodes.update(twinID, nodeID, node);
      expect(updatedNode, isNotNull);

      final nodeUpdated = await client.nodes.get(nodeID);
      expect(nodeUpdated, isNotNull);
      expect(nodeUpdated.location.country, node.location.country);
      expect(nodeUpdated.location.city, node.location.city);
    });

    test('Report node uptime', () async {
      final uptime = ReportUptimeRequest(
        uptime: 100,
        timestamp: DateTime.now().toIso8601String(),
      );

      final response = await client.nodes.reportNodeUptime(twinID, nodeID, uptime);
      expect(response, isNotNull);

      final node = await client.nodes.get(nodeID);
      expect(node, isNotNull);
      expect(node.uptime, isNotNull);
    });
  });
}
