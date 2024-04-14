part of 'latest_exchanges_cubit.dart';

sealed class LatestExchangesState extends Equatable {
  const LatestExchangesState();

  @override
  List<Object> get props => [];
}

final class LatestExchangesInitial extends LatestExchangesState {}

final class LatestExchangesLoading extends LatestExchangesState {}

final class LatestExchangesLoaded extends LatestExchangesState {
  final List<Exchange> exchanges;

  const LatestExchangesLoaded(this.exchanges);

  @override
  List<Object> get props => [exchanges];
}

final class LatestExchangesFailed extends LatestExchangesState {
  final Failure failure;

  const LatestExchangesFailed(this.failure);

  @override
  List<Object> get props => [failure];
}
