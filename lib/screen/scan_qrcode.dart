import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobileScanner;
import 'package:my_flutter_app/screen/qr_overlay.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRCodeScreen extends StatefulWidget {
  const ScanQRCodeScreen({Key? key}) : super(key: key);

  @override
  State<ScanQRCodeScreen> createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  String? qrcode;
  mobileScanner.MobileScannerController cameraController = mobileScanner.MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          mobileScanner.MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: (barcode, args) {
              qrcode = barcode.rawValue!;
              print('Barcode found!' + barcode.rawValue!);
              Navigator.pop(context, barcode.rawValue!);
            },
          ),
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderLength: 20,
                borderWidth: 10,
                borderRadius: 10,
                borderColor: Colors.white,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          // QRScannerOverlay(
          //   overlayColour: Colors.black.withOpacity(0.5),
          // ),
          Positioned(
            bottom: 40,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white24,
              ),
              child: Text(
                maxLines: 3,
                qrcode != null ? '$qrcode' : 'Quét mã QRCode',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            child: buildControlButtons(),
          ),
        ]
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
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as mobileScanner.TorchState) {
                  case mobileScanner.TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case mobileScanner.TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as mobileScanner.CameraFacing) {
                  case mobileScanner.CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case mobileScanner.CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
    );
  }
}