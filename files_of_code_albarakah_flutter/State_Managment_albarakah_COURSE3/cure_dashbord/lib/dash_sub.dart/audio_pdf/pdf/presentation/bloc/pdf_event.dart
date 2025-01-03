
sealed class PdfEvent {}

class GetPdf extends PdfEvent {
int? index;
  GetPdf({
    required this.index,
  });

 }
