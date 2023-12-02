import 'package:equatable/equatable.dart';

enum DeeplinkStateStatus {
  init,
  deeplinkHandling,
  failure,

  authDeeplinkRequested,
  authDeeplinkProcessing,
  authDeeplinkLaunched,

  sendContentDeeplinkInitializing,
  sendContentDeeplinkLaunched,
}

class DeeplinkState extends Equatable {
  final DeeplinkStateStatus status;

  const DeeplinkState({
    this.status = DeeplinkStateStatus.init,
  });

  @override
  List<Object?> get props => [
        status,
      ];

  DeeplinkState copyWith({
    DeeplinkStateStatus? status,
  }) {
    return DeeplinkState(
      status: status ?? this.status,
    );
  }
}
