import 'package:equatable/equatable.dart';
import '../../data/models/destination_model.dart';

abstract class DestinationState extends Equatable {
  const DestinationState();

  @override
  List<Object?> get props => [];
}

class DestinationInitial extends DestinationState {
  const DestinationInitial();
}

class DestinationLoading extends DestinationState {
  const DestinationLoading();
}

class DestinationLoaded extends DestinationState {
  final List<DestinationModel> destinations;
  final String? currentCategory;

  const DestinationLoaded(
    this.destinations, {
    this.currentCategory,
  });

  @override
  List<Object?> get props => [destinations, currentCategory];
}

class CategoriesLoaded extends DestinationState {
  final List<String> categories;
  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class DestinationError extends DestinationState {
  final String message;
  const DestinationError(this.message);

  @override
  List<Object?> get props => [message];
}
