import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SimpleQRTestScreen extends StatefulWidget {
  const SimpleQRTestScreen({super.key});

  @override
  State<SimpleQRTestScreen> createState() => _SimpleQRTestScreenState();
}

class _SimpleQRTestScreenState extends State<SimpleQRTestScreen> {
  String? detectedCode;
  String? detectedFormat;
  String? detectedType;
  List<int>? rawBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner Test'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              print('========== DETECTION TRIGGERED ==========');
              print('Barcodes count: ${capture.barcodes.length}');

              if (capture.barcodes.isNotEmpty) {
                final barcode = capture.barcodes.first;
                print('Barcode type: ${barcode.type}');
                print('Barcode format: ${barcode.format}');
                print('Raw value: ${barcode.rawValue}');
                print('Display value: ${barcode.displayValue}');
                print('Raw bytes: ${barcode.rawBytes}');
                print('Raw bytes length: ${barcode.rawBytes?.length ?? 0}');

                // Try to decode from raw bytes if rawValue is null
                String? finalValue = barcode.rawValue;
                if (finalValue == null || finalValue.isEmpty) {
                  finalValue = barcode.displayValue;
                }
                if ((finalValue == null || finalValue.isEmpty) &&
                    barcode.rawBytes != null &&
                    barcode.rawBytes!.isNotEmpty) {
                  try {
                    finalValue = String.fromCharCodes(barcode.rawBytes!);
                    print('Decoded from rawBytes: $finalValue');
                  } catch (e) {
                    print('Failed to decode rawBytes: $e');
                  }
                }

                setState(() {
                  detectedCode = finalValue ?? 'No value';
                  detectedFormat = barcode.format.toString();
                  detectedType = barcode.type.toString();
                  rawBytes = barcode.rawBytes;
                });
              }
            },
          ),
          if (detectedCode != null)
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'QR Code Detected!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Format:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        detectedFormat ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Type:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        detectedType ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Raw Data:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        detectedCode!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 10,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Data Length:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${detectedCode!.length} characters',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      if (rawBytes != null) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Raw Bytes Length:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${rawBytes!.length} bytes',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
