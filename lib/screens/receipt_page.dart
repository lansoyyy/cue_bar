import 'dart:typed_data';

import 'package:cue_bar/widgets/button_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

class ReceiptScreen extends StatelessWidget {
  int timerate;
  int total;
  List items;

  ReceiptScreen(
      {super.key,
      required this.timerate,
      required this.total,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Receipt',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Receipt',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Bold',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Date: ${DateFormat.yMMMd().add_jm().format(DateTime.now())}',
              style: const TextStyle(
                  fontSize: 16, color: Colors.grey, fontFamily: 'Regular'),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Time rate:',
                    style: TextStyle(
                        fontSize: 24, color: Colors.black, fontFamily: 'Bold'),
                  ),
                  Text(
                    'P$timerate.00',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontFamily: 'Regular'),
                  ),
                ],
              ),
            ),
            const Text(
              'Items:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Bold',
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _buildItem(items[index]['name'], items[index]['price'],
                      items[index]['qty']);
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total: P$total.00',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Bold',
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: ButtonWidget(
                color: Colors.black,
                label: 'Print Receipt',
                onPressed: () {
                  generateReceiptPdf(items, timerate, total);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String name, int price, int qty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$name x $qty',
            style: TextStyle(
                fontSize: 16, color: Colors.grey[800], fontFamily: 'Regular'),
          ),
          Text(
            'P${price * qty}.00',
            style: TextStyle(
                fontSize: 16, color: Colors.grey[800], fontFamily: 'Regular'),
          ),
        ],
      ),
    );
  }

  Future<void> generateReceiptPdf(List items, int timerate, int total) async {
    // Initialize items for testing

    // Calculate total

    // Create a PDF document
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Cue bar and billiards',
              style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              'Receipt',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Date: ${DateFormat.yMMMd().add_jm().format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 16),
          ),
          pw.SizedBox(height: 10),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Time rate:',
                  style: const pw.TextStyle(fontSize: 24),
                ),
                pw.Text(
                  'P$timerate.00',
                  style: const pw.TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          pw.Text(
            'Items:',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          items.isEmpty
              ? pw.SizedBox(height: 20)
              : pw.Container(
                  height: 100,
                  child: pw.ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return pw.Container(
                        margin: const pw.EdgeInsets.symmetric(vertical: 4.0),
                        child: _buildItem1(
                            items[index]['name'], items[index]['price'], 1),
                      );
                    },
                  ),
                ),
          pw.Text(
            'Total: P$total.00',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );

    // Save the PDF to a Uint8List
    final Uint8List pdfBytes = await pdf.save();

    // Print the PDF
    Printing.layoutPdf(onLayout: (format) async => pdfBytes);
  }

// Helper function to build item row
  pw.Widget _buildItem1(String name, int price, int qty) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(name),
        pw.Text('P${(price * qty).toStringAsFixed(2)}'),
      ],
    );
  }
}
