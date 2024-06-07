import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/screens/config_page.dart';
import 'package:cue_bar/screens/home_screen.dart';
import 'package:cue_bar/screens/new/create_customer_screen.dart';
import 'package:cue_bar/screens/products_screen.dart';
import 'package:cue_bar/services/add_receipt.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/button_widget.dart';
import 'package:cue_bar/widgets/drawer_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:cue_bar/widgets/textfield_widget.dart';
import 'package:cue_bar/widgets/toast_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

class PaymentPage extends StatefulWidget {
  double total;
  double payment;
  String user;
  String mode;

  double time;

  List items;

  PaymentPage(
      {super.key,
      required this.mode,
      required this.time,
      required this.total,
      required this.payment,
      required this.user,
      required this.items});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final refno = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextWidget(
              text: 'Cue Bar and Billiards',
              fontSize: 18,
              fontFamily: 'Bold',
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              widget.mode == 'Cash'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: 'P${widget.total}',
                              fontSize: 48,
                              fontFamily: 'Bold',
                              color: Colors.green,
                            ),
                            TextWidget(
                              text: 'Total Payment',
                              fontSize: 14,
                              fontFamily: 'Medium',
                              color: Colors.black,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        const SizedBox(
                            height: 100,
                            child: VerticalDivider(
                              color: Colors.black,
                            )),
                        const SizedBox(
                          width: 25,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: 'P${widget.payment - widget.total}',
                              fontSize: 48,
                              fontFamily: 'Bold',
                              color: Colors.green,
                            ),
                            TextWidget(
                              text: 'Change',
                              fontSize: 14,
                              fontFamily: 'Medium',
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: 'P${widget.total}',
                          fontSize: 48,
                          fontFamily: 'Bold',
                          color: Colors.green,
                        ),
                        TextWidget(
                          text: 'Total Payment',
                          fontSize: 14,
                          fontFamily: 'Medium',
                          color: Colors.black,
                        ),
                      ],
                    ),
              widget.mode == 'Card'
                  ? TextFieldWidget(
                      controller: refno,
                      label: 'Reference Number',
                    )
                  : const SizedBox(
                      height: 20,
                    ),
              widget.mode == 'GCash'
                  ? Image.asset(
                      'assets/images/gcash.jpg',
                      height: 800,
                    )
                  : const SizedBox(
                      height: 20,
                    ),
              const SizedBox(
                height: 50,
              ),
              ButtonWidget(
                color: Colors.green,
                label: 'PAID',
                onPressed: () {
                  addReceipt(
                      widget.user,
                      widget.total,
                      widget.payment - widget.total,
                      [],
                      widget.mode,
                      refno.text);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                  generateReceiptPdf(
                      widget.items, widget.time.toInt(), widget.total.toInt());
                },
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> generateReceiptPdf(List items, int timerate, int total) async {
    DateTime now = DateTime.now();

    // Subtract 3 hours from the current date and time
    DateTime subtractedDateTime =
        now.subtract(Duration(hours: widget.time.toInt()));

    // Define the format you want for the date and time
    DateFormat dateFormat = DateFormat('HH:mm: aa');
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
                  '${dateFormat.format(subtractedDateTime)} - ${dateFormat.format(now)}',
                ),
                pw.Text(
                  'P$timerate.00',
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
                        child: _buildItem1(items[index]['name'],
                            items[index]['price'].toInt(), 1),
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
