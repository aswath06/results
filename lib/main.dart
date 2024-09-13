import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart'; // Ensure this import is present
import 'pdf_page.dart' as pdf_page; // Prefix the PdfPage import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: BackgroundImage(),
      ),
    );
  }
}

class BackgroundImage extends StatefulWidget {
  const BackgroundImage({super.key});

  @override
  _BackgroundImageState createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImage> {
  final ScreenshotController _screenshotController = ScreenshotController();

  void _shareScreenshot() async {
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/screenshot.png');
        await file.writeAsBytes(image);
        await Share.shareXFiles(
          [XFile(file.path)], // Use XFile for the file path
          text: 'Here is a screenshot!',
        );
      }
    } catch (e) {
      // Handle error
      print('Error sharing screenshot: $e');
    }
  }

  void _onDownloadPdfPressed() async {
    try {
      final filePath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pdf_page.PdfPage(
            onPdfGenerated: (filePath) {
              OpenFile.open(filePath); // Open the PDF file after generation
            },
          ),
        ),
      );
      if (filePath == null) {
        // Handle case where PDF generation is not successful
      }
    } catch (e) {
      // Handle error
      print('Error navigating to PDF page: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double currentValue = 8.1;
    final double minValue = 1.0;
    final double maxValue = 10.0;

    final double normalizedValue =
        (currentValue - minValue) / (maxValue - minValue);

    return Screenshot(
      controller: _screenshotController,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _buildTitleText("You are Excellent,"),
                  const SizedBox(height: 5),
                  _buildTitleText("Aswath M", isBold: true, fontSize: 25),
                  const SizedBox(height: 5),
                  _buildTable(context),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: _buildCupertinoBackButton(),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: _buildImageButton(Icons.share, _shareScreenshot),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.10,
            left: MediaQuery.of(context).size.width * 0.5 - 150,
            child: _buildCenteredCircle(context, normalizedValue),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.7,
                  child: Image.asset(
                    "assets/bottom.png",
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 70,
                  left: MediaQuery.of(context).size.width * 0.5 - 150,
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(221, 0, 108, 196),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _onDownloadPdfPressed,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Download as PDF",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Image.asset(
                            "assets/pdf.png",
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleText(String text,
      {bool isBold = false, double fontSize = 15}) {
    return Text(
      text,
      style: GoogleFonts.aBeeZee(
        color: Colors.black,
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Table(
              border: TableBorder.symmetric(
                outside: BorderSide(color: Colors.grey),
              ),
              columnWidths: {
                0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.45),
                1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.2),
                2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.2),
              },
              children: [
                _buildTableRow('ENGINEERING MATHEMATICS', 'Pass', 'A'),
                _buildTableRow('ENGINEERING PHYSICS', 'Fail', 'B'),
                _buildTableRow('ENGINEERING CHEMISTRY', 'Pass', 'C'),
                _buildTableRow('STARTUP MANAGEMENT', 'Pass', 'A+'),
                _buildTableRow('FUNDAMENTALS OF COMPUTING', 'Fail', 'O'),
                _buildTableRow('FOUNDATION ENGLISH', 'Pass', 'A'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String subject, String status, String grade) {
    return TableRow(
      children: [
        _buildTableCell(subject),
        _buildTableCell(
            status,
            status == 'Pass' ? Colors.green : Colors.red,
            status == 'Pass'
                ? const Color(0xFFE6F9E6)
                : const Color(0xFFFFE6E6),
            true),
        _buildTableCell(
          grade,
          Colors.black,
          const Color(0xFFE6EFFF),
        ),
      ],
    );
  }

  Widget _buildTableCell(String text,
      [Color? textColor, Color? backgroundColor, bool isSecondColumn = false]) {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          right: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.aBeeZee(
          color: textColor ?? Colors.black,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCupertinoBackButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Icon(
        CupertinoIcons.back,
        size: 36.0,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).pop(); // Go back to the previous screen
      },
    );
  }

  Widget _buildImageButton(IconData iconData, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(
        iconData,
        size: 24,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildCenteredCircle(BuildContext context, double normalizedValue) {
    return Container(
      width: 300,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: normalizedValue,
                    strokeWidth: 12,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "cpga-8.1%",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Semester-1",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: -20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_left,
                size: 70,
                color: Colors.black,
              ),
              onPressed: () {
                // Handle left arrow action
              },
            ),
          ),
          Positioned(
            right: -20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_right,
                size: 70,
                color: Colors.black,
              ),
              onPressed: () {
                // Handle right arrow action
              },
            ),
          ),
        ],
      ),
    );
  }
}
