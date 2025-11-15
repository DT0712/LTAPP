import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/destination_repository.dart';
import 'destination_event.dart';
import 'destination_state.dart';

class DestinationBloc extends Bloc<DestinationEvent, DestinationState> {
  final DestinationRepository repository;

  DestinationBloc({required this.repository})
      : super(const DestinationInitial()) {
    on<FetchAllDestinations>(_onFetchAllDestinations);
    on<FetchDestinationsByCategory>(_onFetchDestinationsByCategory);
    on<SearchDestinations>(_onSearchDestinations);
    on<FetchTopRatedDestinations>(_onFetchTopRatedDestinations);
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchAllDestinations(
    FetchAllDestinations event,
    Emitter<DestinationState> emit,
  ) async {
    emit(const DestinationLoading());
    try {
      final destinations = await repository.getAllDestinations();
      emit(DestinationLoaded(destinations));
    } catch (e) {
      emit(DestinationError(e.toString()));
    }
  }

  Future<void> _onFetchDestinationsByCategory(
    FetchDestinationsByCategory event,
    Emitter<DestinationState> emit,
  ) async {
    emit(const DestinationLoading());
    try {
      final destinations =
          await repository.getDestinationsByCategory(event.category);
      emit(DestinationLoaded(
        destinations,
        currentCategory: event.category,
      ));
    } catch (e) {
      emit(DestinationError(e.toString()));
    }
  }

  Future<void> _onSearchDestinations(
    SearchDestinations event,
    Emitter<DestinationState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const FetchAllDestinations());
      return;
    }

    emit(const DestinationLoading());
    try {
      final destinations = await repository.searchDestinations(event.query);
      emit(DestinationLoaded(destinations));
    } catch (e) {
      emit(DestinationError(e.toString()));
    }
  }

  Future<void> _onFetchTopRatedDestinations(
    FetchTopRatedDestinations event,
    Emitter<DestinationState> emit,
  ) async {
    emit(const DestinationLoading());
    try {
      final destinations = await repository.getTopRatedDestinations();
      emit(DestinationLoaded(destinations));
    } catch (e) {
      emit(DestinationError(e.toString()));
    }
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<DestinationState> emit,
  ) async {
    emit(const DestinationLoading());
    try {
      final categories = await repository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(DestinationError(e.toString()));
    }
  }
}
