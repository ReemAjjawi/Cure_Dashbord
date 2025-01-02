// ignore_for_file: public_member_api_docs, sort_constructors_first

sealed class CodeEvent {}



class GenerateCode extends CodeEvent {
  int numberOfCodes;
  List<int> subjectsNumber;
  GenerateCode({
    required this.numberOfCodes,
    required this.subjectsNumber,
  });
 
}
