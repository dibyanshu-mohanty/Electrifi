import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sizer/sizer.dart';

class QrCodeView extends StatefulWidget {
  const QrCodeView({Key? key}) : super(key: key);

  @override
  State<QrCodeView> createState() => _QrCodeViewState();
}

class _QrCodeViewState extends State<QrCodeView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }
  bool isFound = false;
  Future<void> readPersonalData(String scannedData) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseDatabase.instance.ref().once().then((event) async{
      final response = event.snapshot.value as Map;
      Map temp = response["System"]["Config"];
      final data = temp.keys.toList();
      String tempo = data.firstWhere((element) => element == scannedData);
      if(tempo.isNotEmpty){
        FirebaseDatabase.instance.ref().child("auth").child(user!.uid).update({
          "isConnected" : true
        });
      } else {
         Fluttertoast.showToast(msg: "No Device Found !");
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if(result != null){
        readPersonalData(scanData.code!);
        controller.stopCamera();
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Color(0xFF7A5CE0),
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 250.0),
      ),
      Container(
        margin: EdgeInsets.only(top: 5.h),
        child: Text(
          "Scan the QR code on the Device to pair it up with the app.",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 4.5.w),
        ),
      ),
      Container(
        color: Colors.transparent,
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.transparent,
              margin: const EdgeInsets.all(8),
              child: IconButton(
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.flash_on,
                    color: Colors.white,
                  )),
            ),
            Container(
                margin: const EdgeInsets.all(8),
                child: IconButton(
                    onPressed: () async {
                      await controller?.flipCamera();
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                    ))),
          ],
        ),
      ),
    ]));
  }
}
