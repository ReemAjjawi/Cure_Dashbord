abstract class SuccessSituation {}

class DataSuccess extends SuccessSituation {}

class DataSuccessList<T> extends SuccessSituation {
  List<T> data;
  DataSuccessList({
    required this.data,
  });
}

class DataSuccessObject<T> extends SuccessSituation {
  T data;
  DataSuccessObject({
    required this.data,
  });
}







