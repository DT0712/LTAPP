import 'package:equatable/equatable.dart';

abstract class DestinationEvent extends Equatable {
  const DestinationEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllDestinations extends DestinationEvent {
  const FetchAllDestinations();
}

class FetchDestinationsByCategory extends DestinationEvent {
  final String category;
  const FetchDestinationsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchDestinations extends DestinationEvent {
  final String query;
  const SearchDestinations(this.query);

  @override
  List<Object?> get props => [query];
}

class FetchTopRatedDestinations extends DestinationEvent {
  const FetchTopRatedDestinations();
}

class FetchCategories extends DestinationEvent {
  const FetchCategories();
}
