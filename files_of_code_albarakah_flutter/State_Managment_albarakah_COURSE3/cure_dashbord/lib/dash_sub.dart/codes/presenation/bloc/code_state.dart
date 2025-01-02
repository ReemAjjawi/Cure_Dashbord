import '../../response_code_model.dart';

sealed class CodeState {}

final class CodeLoading extends CodeState {}

final class SuccessGenerateCode extends CodeState {
  List<CodeResponse> code;
  SuccessGenerateCode({required this.code});
}
class CodeEmpty extends CodeState  {
  
}
class FailureCodeState extends CodeState {
  final String message;

  FailureCodeState({required this.message});
}
