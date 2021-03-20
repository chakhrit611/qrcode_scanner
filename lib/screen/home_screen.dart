import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController input = new TextEditingController();
  bool isCameraPermissionEnabled = false;

  void scan() async {
    String cameraScanResult = await scanner.scan();
    setState(() {
      input.text = cameraScanResult;
    });
  }

  void share() {}
  void copy() {}
  void checkPermissions() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        isCameraPermissionEnabled = true;
      });
    }
    if (await Permission.speech.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scaner"),
      ),
      body: !isCameraPermissionEnabled
          ? Center(
              child: ElevatedButton(
                onPressed: () => openAppSettings(),
                child: Text("เปิดกล้องค้าบ"),
              ),
            )
          : Container(
              child: Column(
                children: [
                  Text("กดปุ่มเพื่อสแกน"),
                  Stack(children: [
                    TextFormField(
                      controller: input,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 7,
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Column(children: [
                        ElevatedButton.icon(
                          onPressed: copy,
                          icon: Icon(Icons.copy),
                          label: Text("คัดลอก"),
                        ),
                        ElevatedButton.icon(
                          onPressed: share,
                          icon: Icon(Icons.share),
                          label: Text("แชร์"),
                        ),
                      ]),
                    ),
                  ]),
                  Container(
                      child: ElevatedButton.icon(
                    onPressed: scan,
                    icon: Icon(Icons.camera),
                    label: Text("สแกน"),
                  ))
                ],
              ),
            ),
    );
  }
}
