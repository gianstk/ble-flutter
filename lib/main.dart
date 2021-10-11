import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'DeviceWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter BLE PoC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  List<DeviceWidget> devicesWidgetList = <DeviceWidget>[];

  @override
  void initState() {
    super.initState();
    // Listen to scan results
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _showDeviceToList(result.device, result.rssi);
      }
    });
  }

  void _scanDevices() {
    flutterBlue.startScan(
        timeout: Duration(seconds: 2), allowDuplicates: false);
  }

  void _clearDevices() {
    setState(() {
      devicesList.clear();
      devicesWidgetList.clear();
    });
  }

  // add a new device to a 'devicesList' and prevent duplication
  void _showDeviceToList(final BluetoothDevice device, int rssi) {
    if (!devicesList.contains(device)) {
      setState(() {
        devicesList.add(device);
        devicesWidgetList.add(new DeviceWidget(
            name: device.name, rssi: rssi, id: device.id.toString()));
        print("add new device! ${device.name}");
      });
    }
  }

  // ListView _buildDevicesListView() {
  //   return ListView.builder(
  //     itemCount: devicesWidgetList.length,
  //     scrollDirection: Axis.vertical,
  //     shrinkWrap: true,
  //     itemBuilder: (context, index) =>
  //         DeviceWidget(name: "a", rssi: 10, id: "a"),
  //   );
  //   // return ListView(
  //   //   scrollDirection: Axis.vertical,
  //   //   shrinkWrap: true,
  //   //   physics: AlwaysScrollableScrollPhysics(),
  //   //   children: devicesWidgetList,
  //   // );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: _scanDevices,
                child: const Text("Scan Devices"),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: _clearDevices,
                child: const Text("Clear Devices"),
              ),
            ),
            SizedBox(height: 40),
            Flexible(
              child: ListView.builder(
                  itemCount: devicesWidgetList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => devicesWidgetList[index]),
            )
          ],
        ),
      ),
    );
  }
}
