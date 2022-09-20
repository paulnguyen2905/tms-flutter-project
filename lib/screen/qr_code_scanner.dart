import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if(Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQRView(context),
          Positioned(
            bottom: 10,
            child: buildResult(),
          ),
          Positioned(
            top: 50,
            child: buildControlButtons(),
          ),
        ],
      ),
    );
  }

  Widget buildQRView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderLength: 20,
        borderWidth: 10,
        borderRadius: 10,
        borderColor: Colors.white,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  Widget buildControlButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: FutureBuilder<bool?>(
              future: controller?.getFlashStatus(),
              builder: (context, snapshot) {
                if(snapshot.data != null) {
                  return Icon(snapshot.data! ? Icons.flash_on : Icons.flash_off);
                } else {
                  return Container();
                }
              }
            ),
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            }
          ),
          IconButton(
            icon: FutureBuilder(
                future: controller?.getCameraInfo(),
                builder: (context, snapshot) {
                  if(snapshot.data != null) {
                    return Icon(Icons.switch_camera);
                  } else {
                    return Container();
                  }
                }
            ),
            onPressed: () async {
              await controller?.flipCamera();
              setState(() {});
            }
          ),
        ],
      ),
    );
  }

  Widget buildResult() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        barcode != null ? 'Mã: ${barcode!.code}' : 'Quét mã QRCode',
        maxLines: 3,
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        barcode = scanData;
        if(barcode != null) {
          await controller.pauseCamera();
          Navigator.pop(context, '${barcode!.code}');
        }
      });
    });
    this.controller!.pauseCamera();
    this.controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
