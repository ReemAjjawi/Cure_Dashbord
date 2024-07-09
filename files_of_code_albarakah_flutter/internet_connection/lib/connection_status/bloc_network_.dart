import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection/connection_status/state_network.dart';
import 'package:meta/meta.dart';

import 'event_network.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  StreamSubscription? subscription;
  InternetBloc() : super(InternetInitial()) {
    log("iam check status of connection");
    on<InternetEvent>((event, emit) {
      if (event is ConnectedEvent) {
        log("iam in internetBloc ============================ConnectedEvent ");
        emit(ConnectedState(message: "Connected"));
      } else if (event is NotConnectedEvent) {
        log("iam in internetBloc ============================NotConnectedEvent ");

        emit(NotConnectedState(message: "Not Connected"));
      }
    });

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        log("Myyyyyyyyyyyy internet");
        add(ConnectedEvent());
        
        print(result);
      } else {
        log("there is no internet");
        add(NotConnectedEvent());
      }
    });
  }

  @override
  Future<void> close() {
    subscription!.cancel();
    return super.close();
  }
}
