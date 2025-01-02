class UserNumbersInSubjectModel {
  final List<Datum> data;

  UserNumbersInSubjectModel({required this.data});

  factory UserNumbersInSubjectModel.fromMap(Map<String, dynamic> map) {
    return UserNumbersInSubjectModel(
      data: List<Datum>.from(
        (map['data'] as List<dynamic>).map((item) => Datum.fromMap(item)),
      ),
    );
  }
}

class Datum {
  final int subjectId;
  final String subjectName;
  final int userCount;

  Datum({
    required this.subjectId,
    required this.subjectName,
    required this.userCount,
  });

  factory Datum.fromMap(Map<String, dynamic> map) {
    return Datum(
      subjectId: map['subject_id'],
      subjectName: map['subject_name'],
      userCount: map['user_count'],
    );
  }
}
