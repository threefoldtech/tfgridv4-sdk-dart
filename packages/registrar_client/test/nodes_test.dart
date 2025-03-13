import 'package:bip39/bip39.dart';
import 'package:registrar_client/registrar_client.dart';
import 'package:test/test.dart';

void main() async {
  group('Test Nodes', () {
    final mnemonic = generateMnemonic();
    final client = RegistrarClient(
        baseUrl: 'https://registrar.dev4.grid.tf/v1', mnemonicOrSeed: mnemonic);
    int farmID = 0;
    int nodeID = 0;
    test('Register node', () async {
      await client.accounts.create();
      final stellarAddress =
          "GC6CG2ME7UCJ56CEQ223QWWZ6N3UGTSXVNRJGDTE2DXUO4NQBLXZRWU5";
      final farmName = '${DateTime.now().millisecondsSinceEpoch ~/ 1000}farm';
      final farmIDCreated =
          await client.farms.create(farmName, true, stellarAddress);
      expect(farmID, isNotNull);
      expect(farmID, isA<int>());
      farmID = farmIDCreated;

      final node = NodeRegistrationRequest(
        farmID: farmID,
        interfaces: [
          Interface(
            name: 'eth0',
            mac: '00:11:22:33:44:55',
            ips: '192.168.1.100',
          ),
          Interface(
            name: 'wlan0',
            mac: '66:77:88:99:AA:BB',
            ips: '192.168.1.101',
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
      final nodes = await client.nodes.list(NodeFilter(twinID: client.twinId!));
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

      final updatedNode = await client.nodes.update(nodeID, node);
      expect(updatedNode, isNotNull);

      final nodeUpdated = await client.nodes.get(nodeID);
      expect(nodeUpdated, isNotNull);
      expect(nodeUpdated.location.country, node.location.country);
      expect(nodeUpdated.location.city, node.location.city);
    });

    test('Report node uptime', () async {
      final uptime = ReportUptimeRequest(
        uptime: Duration(hours: 1, minutes: 30),
        timestamp: DateTime.now(),
      );

      final response =
          await client.nodes.reportNodeUptime(nodeID, uptime);
      expect(response, isNotNull);

      final node = await client.nodes.get(nodeID);
      expect(node, isNotNull);
      expect(node.uptime, isNotNull);
    });
  });
}
