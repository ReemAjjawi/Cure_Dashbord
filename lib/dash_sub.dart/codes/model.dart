// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CodeGeneration {
  int number_of_codes;
  List<int> subjects;
  CodeGeneration({
    required this.number_of_codes,
    required this.subjects,
  });

  CodeGeneration copyWith({
    int? number_of_codes,
    List<int>? subjects,
  }) {
    return CodeGeneration(
      number_of_codes: number_of_codes ?? this.number_of_codes,
      subjects: subjects ?? this.subjects,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number_of_codes': number_of_codes,
      'subjects': subjects,
    };
  }

  factory CodeGeneration.fromMap(Map<String, dynamic> map) {
    return CodeGeneration(
      number_of_codes: map['number_of_codes'] as int,
      subjects: List<int>.from((map['subjects'] as List<int>),
      )  );
  }

  String toJson() => json.encode(toMap());

  factory CodeGeneration.fromJson(String source) => CodeGeneration.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CodeGeneration(number_of_codes: $number_of_codes, subjects: $subjects)';

  @override
  bool operator ==(covariant CodeGeneration other) {
    if (identical(this, other)) return true;
  
    return 
      other.number_of_codes == number_of_codes &&
      listEquals(other.subjects, subjects);
  }

  @override
  int get hashCode => number_of_codes.hashCode ^ subjects.hashCode;
}
