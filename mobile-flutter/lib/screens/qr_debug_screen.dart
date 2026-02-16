import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Debug screen to test QR code scanning and view raw data
class QRDebugScreen extends StatefulWidget {
  const QRDebugScreen({super.key});

  @override
  State<QRDebugScreen> createState() => _QRDebugScreenState();
}

class _QRDebugScreenState extends State<QRDebugScreen> {
  final MobileScannerController _controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
  );

  String? rawValue;
  String? displayValue;
  String? format;
  String? type;
  List<int>? rawBytes;
  String? decodedFromBytes;
  int detectionCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Debug Scanner'