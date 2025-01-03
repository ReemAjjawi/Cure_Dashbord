import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../../core/resources/managers/colors_manager.dart';
import '../models/response/response_code_model.dart';

class ActivationCodes extends StatelessWidget {
  Future<File> createPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Column(
              children: codes.map((code) {
                return pw.Padding(
                  padding:
                      const pw.EdgeInsets.only(bottom: 15.0), // Add spacing
                  child: pw.Text(code.activation_code),
                );
              }).toList(),
            ),
          ];
        },
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/codes.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> sharePdf(File pdfFile) async {
    await Share.shareXFiles([XFile(pdfFile.path)],
        subject: 'Here are the codes!');
  }

  const ActivationCodes({super.key, required this.codes});

  final List<CodeResponse> codes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01,
            vertical: MediaQuery.of(context).size.height * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "الأكواد",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFEBEDEC),
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: codes.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                                color: const Color(0xFF749081), width: 0.5),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                codes[index].activation_code,
                                style: TextStyle(
                                  color: ColorsManager.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () async {
                        try {
                          final pdfFile = await createPdf();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('File saved at ${pdfFile.path}')),
                          );
                          await OpenFilex.open(
                              pdfFile.path); // Opens the saved file
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error saving file: $e')),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.save_alt,
                        size: 45,
                        color: Color(0xFF43584D),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final pdfFile = await createPdf();
                        await sharePdf(pdfFile);
                      },
                      icon: const Icon(
                        Icons.share,
                        size: 45,
                        color: Color(0xFF43584D),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "save",
                      style: TextStyle(color: Color(0xFF43584D)),
                    ),
                    Text(
                      "share",
                      style: TextStyle(color: Color(0xFF43584D)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
