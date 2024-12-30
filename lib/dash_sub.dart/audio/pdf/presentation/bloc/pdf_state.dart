
import 'dart:io';

import '../../model.dart';

sealed class PdfState {}

final class PdfLoading extends PdfState {}


final class PdfFile extends PdfState {
  PdfModel pdf;
    PdfFile({required this.pdf});

}
final class showpdf extends PdfState {
File pfile;
    showpdf({required this.pfile});

}
class FailurePdfState extends PdfState {
  final String message;

  FailurePdfState({required this.message});
}
