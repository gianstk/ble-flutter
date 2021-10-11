import 'package:flutter/material.dart';

class DeviceWidget extends StatefulWidget {
  DeviceWidget(
      {Key? key, required this.name, required this.rssi, required this.id})
      : super(key: key);

  final String name;
  final String id;
  final int rssi;

  @override
  _DeviceWidgetState createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('name: ${widget.name}'),
              Text('id: ${widget.id}'),
              Text('rssi: ${widget.rssi.toString()}'),
            ],
          ),
        ),
      ),
    );
  }
}
