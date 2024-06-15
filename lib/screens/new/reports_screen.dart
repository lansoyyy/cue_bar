import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/widgets/button_widget.dart';
import 'package:cue_bar/widgets/drawer_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTimeRange? _selectedDateRange;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Receipts').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              );
            }

            final data = snapshot.requireData;

            // Apply date range filtering
            List<QueryDocumentSnapshot> filteredData =
                _selectedDateRange == null
                    ? data.docs.toList()
                    : data.docs.where((doc) {
                        DateTime docDate = doc['dateTime'].toDate();
                        return docDate.isAfter(_selectedDateRange!.start
                                .subtract(const Duration(days: 1))) &&
                            docDate.isBefore(_selectedDateRange!.end
                                .add(const Duration(days: 1)));
                      }).toList();
            return FloatingActionButton(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () {
                generatePdf(filteredData);
              },
            );
          }),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Reports',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextWidget(
                    text: _selectedDateRange == null
                        ? 'No date range selected'
                        : 'Dates: ${DateFormat('MM/dd/yyyy').format(_selectedDateRange!.start)} to ${DateFormat('MM/dd/yyyy').format(_selectedDateRange!.end)}',
                    fontFamily: 'Bold',
                    fontSize: 18,
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  ButtonWidget(
                    width: 125,
                    fontSize: 18,
                    color: Colors.blue,
                    label: 'Select Dates',
                    onPressed: () async {
                      DateTime today = DateTime.now();
                      DateTime tomorrow = today.add(const Duration(days: 1));
                      DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        initialDateRange: DateTimeRange(
                          start: today,
                          end: tomorrow,
                        ),
                      );
                      if (picked != null && picked != _selectedDateRange) {
                        setState(() {
                          _selectedDateRange = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Receipts')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(child: Text('Error'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                      );
                    }

                    final data = snapshot.requireData;

                    // Apply date range filtering
                    List<QueryDocumentSnapshot> filteredData =
                        _selectedDateRange == null
                            ? data.docs.toList()
                            : data.docs.where((doc) {
                                DateTime docDate = doc['dateTime'].toDate();
                                return docDate.isAfter(_selectedDateRange!.start
                                        .subtract(const Duration(days: 1))) &&
                                    docDate.isBefore(_selectedDateRange!.end
                                        .add(const Duration(days: 1)));
                              }).toList();

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey, // Set border color
                              width: 1.0, // Set border width
                            ),
                            borderRadius:
                                BorderRadius.circular(8.0), // Set border radius
                          ),
                          child: DataTable(
                            columnSpacing: 100,
                            columns: const [
                              DataColumn(label: Text('No.')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Time')),
                              DataColumn(label: Text('Total')),
                            ],
                            rows: [
                              for (int i = 0; i < filteredData.length; i++)
                                DataRow(cells: [
                                  DataCell(Text('${i + 1}')),
                                  DataCell(Text(filteredData[i]['name'])),
                                  DataCell(Text(DateFormat.yMMMd().format(
                                      filteredData[i]['dateTime'].toDate()))),
                                  DataCell(Text(
                                    DateFormat('hh:mm a').format(
                                        filteredData[i]['dateTime'].toDate()),
                                  )),
                                  DataCell(
                                      Text('P${filteredData[i]['total']}.00')),
                                ]),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void generatePdf(List tableDataList) async {
    final pdf = pw.Document();
    final tableHeaders = [
      'Number',
      'Name',
      'Date',
      'Time',
      'Total',
    ];

    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));

    String cdate1 =
        DateFormat("MM/dd/yyyy").format(_selectedDateRange?.start ?? today);
    String cdate2 =
        DateFormat("MM/dd/yyyy").format(_selectedDateRange?.end ?? tomorrow);

    List<List<String>> tableData = [];
    for (var i = 0; i < tableDataList.length; i++) {
      tableData.add([
        '${i + 1}',
        tableDataList[i]['name'],
        DateFormat.yMMMd().format(tableDataList[i]['dateTime'].toDate()),
        DateFormat('hh:mm a').format(tableDataList[i]['dateTime'].toDate()),
        'P${tableDataList[i]['total']}.00',
      ]);
    }

    pdf.addPage(
      pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        pageFormat: PdfPageFormat.letter,
        orientation: pw.PageOrientation.portrait,
        build: (context) => [
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Cue Bar with Billiards',
                    style: const pw.TextStyle(
                      fontSize: 18,
                    )),
                pw.SizedBox(height: 10),
                pw.Text(
                  style: const pw.TextStyle(
                    fontSize: 15,
                  ),
                  'Report',
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                  cdate1 == cdate2 ? cdate1 : '$cdate1 - $cdate2',
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: tableHeaders,
            data: tableData,
            headerDecoration: const pw.BoxDecoration(),
            rowDecoration: const pw.BoxDecoration(),
            headerHeight: 25,
            cellHeight: 45,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
            },
          ),
          pw.SizedBox(height: 20),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());

    final output = await getTemporaryDirectory();
    final file = io.File("${output.path}/report.pdf");
    await file.writeAsBytes(await pdf.save());
  }
}
