import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart'; // Import OpenFile to open the PDF file
import 'package:flutter/services.dart' show rootBundle;

class PdfPage extends StatefulWidget {
  const PdfPage({super.key, required this.onPdfGenerated});

  final void Function(String filePath) onPdfGenerated;

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  void initState() {
    super.initState();
    _generateAndOpenPdf();
  }

  Future<void> _generateAndOpenPdf() async {
    try {
      final filePath = await generatePdf();
      OpenFile.open(filePath); // Open the PDF file directly
      widget.onPdfGenerated(filePath); // Notify when the PDF is generated
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }

  Future<String> generatePdf() async {
    final pdf = pw.Document();

    final headingImage = pw.MemoryImage(
      (await rootBundle.load('assets/heading.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment:
                pw.CrossAxisAlignment.center, // Center horizontally
            children: [
              pw.Image(
                headingImage,
                width: context.page.pageFormat.width *
                    0.8, // Reduced width (80% of page)
                height: 120, // Adjust height proportionally
              ),
              pw.SizedBox(height: 20), // Space below the heading image

              // Add table header information
              pw.Text(
                'Semester End Examinations JUL 2024 - Results',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 10),
              // Add Register No, UMIS No, Name, etc.
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Register No: 7376232IT116',
                      style: pw.TextStyle(fontSize: 12)),
                  pw.Text('UMIS No: 2303737620522010',
                      style: pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Name: ASWATH M', style: pw.TextStyle(fontSize: 12)),
                  pw.Text('Batch: 2023 - 2027',
                      style: pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text('Degree & Branch: B.Tech. INFORMATION TECHNOLOGY',
                  style: pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 20),

              // Increased Table Height
              pw.Container(
                height: 300, // Increased height for more row space
                child: pw.Table.fromTextArray(
                  headers: [
                    'S.No',
                    'Course Code',
                    'Course Title',
                    'Semester',
                    'Grade',
                    'Category',
                    'Result'
                  ],
                  columnWidths: {
                    0: const pw.FixedColumnWidth(40), // S.No
                    1: const pw.FixedColumnWidth(70), // Course Code
                    2: const pw.FlexColumnWidth(
                        2.5), // Increase width for Course Title
                    3: const pw.FixedColumnWidth(50), // Semester
                    4: const pw.FixedColumnWidth(50), // Grade
                    5: const pw.FixedColumnWidth(60), // Category
                    6: const pw.FixedColumnWidth(50), // Result
                  },
                  data: [
                    [
                      '1',
                      '22CH203',
                      'ENGINEERING CHEMISTRY II',
                      '2',
                      'A+',
                      'Regular',
                      'PASS'
                    ],
                    [
                      '2',
                      '22GE002',
                      'COMPUTATIONAL PROBLEM SOLVING',
                      '2',
                      'A',
                      'Regular',
                      'PASS'
                    ],
                    [
                      '3',
                      '22GE003',
                      'BASICS OF ELECTRICAL ENGINEERING',
                      '2',
                      'A+',
                      'Regular',
                      'PASS'
                    ],
                    [
                      '4',
                      '22IT206',
                      'DIGITAL COMPUTER ELECTRONICS',
                      '2',
                      'A',
                      'Regular',
                      'PASS'
                    ],
                    [
                      '5',
                      '22MA201',
                      'ENGINEERING MATHEMATICS II',
                      '2',
                      'A+',
                      'Regular',
                      'PASS'
                    ],
                    [
                      '6',
                      '22PH202',
                      'ELECTROMAGNETISM AND MODERN PHYSICS',
                      '2',
                      'A',
                      'Regular',
                      'PASS'
                    ],
                  ],
                  border: pw.TableBorder.all(),
                  cellStyle: pw.TextStyle(fontSize: 10),
                  headerStyle: pw.TextStyle(
                      fontSize: 10,
                      fontWeight:
                          pw.FontWeight.bold), // Reduced header font size
                  cellAlignment: pw.Alignment.center,
                  headerAlignment: pw.Alignment.center,
                  defaultColumnWidth: pw.FlexColumnWidth(),
                ),
              ),

              pw.SizedBox(height: 20),

              // Disclaimer text
              pw.Text(
                'Disclaimer: The published is provisional only. We are not responsible for any '
                'inadvertent error that may have crept in the data / results being published. '
                'The Final Grade Sheet issued by the Institute should only be considered authentic.',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.black,
                ),
                textAlign: pw.TextAlign.justify,
              ),

              pw.Spacer(),

              // Centered Footer Text
              pw.Align(
                alignment: pw.Alignment.bottomCenter,
                child: pw.Text(
                  '* System Generated Report',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.red),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );

    final outputDir = await getExternalStorageDirectory();
    if (outputDir == null) {
      throw Exception('Unable to get external storage directory');
    }

    final filePath = '${outputDir.path}/result_report.pdf';
    final outputFile = File(filePath);
    await outputFile.writeAsBytes(await pdf.save());

    return filePath; // Return the file path for confirmation or further use
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generating PDF...'),
      ),
      body: Center(
        child:
            const CircularProgressIndicator(), // Indicate that the PDF is being generated
      ),
    );
  }
}
