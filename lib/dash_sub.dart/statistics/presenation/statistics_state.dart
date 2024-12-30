
import 'package:cure/dash_sub.dart/statistics/model.dart';

sealed class StatisticsState {}

final class StatisticsLoading extends StatisticsState {}

final class SuccessGetNumberOfUser extends StatisticsState {
  List<Datum> num;
  SuccessGetNumberOfUser({required this.num});
}
  
class FailureStatisticsState extends StatisticsState {
  final String message;

  FailureStatisticsState({required this.message});
}
