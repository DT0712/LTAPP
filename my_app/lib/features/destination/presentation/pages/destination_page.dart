import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/destination_bloc.dart';
import '../bloc/destination_event.dart';
import '../bloc/destination_state.dart';
import '../widgets/destination_card.dart';
import '../widgets/category_filter_chip.dart';
import 'destination_detail_page.dart';
import '../../data/repositories/destination_repository.dart';

class DestinationPage extends StatefulWidget {
  static const String routeName = '/destination';

  const DestinationPage({Key? key}) : super(key: key);

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  late DestinationBloc _destinationBloc;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _destinationBloc = DestinationBloc(
      repository: DestinationRepository(),
    );
    // Lấy tất cả điểm đến khi khởi tạo
    _destinationBloc.add(const FetchAllDestinations());
    // Lấy danh sách danh mục
    _destinationBloc.add(const FetchCategories());

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _destinationBloc.close();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      _destinationBloc.add(SearchDestinations(_searchController.text));
    } else {
      _destinationBloc.add(const FetchAllDestinations());
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null;
        _destinationBloc.add(const FetchAllDestinations());
      } else {
        _selectedCategory = category;
        _destinationBloc.add(FetchDestinationsByCategory(category));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DestinationBloc>(
      create: (context) => _destinationBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Điểm Đến',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.red),
              onPressed: () {
                // TODO: Điều hướng đến trang yêu thích
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm điểm đến...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            // Category Filters
            BlocBuilder<DestinationBloc, DestinationState>(
              builder: (context, state) {
                if (state is CategoriesLoaded) {
                  _categories = state.categories;
                }
                if (_categories.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // "All" button
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: const Text('Tất cả'),
                              selected: _selectedCategory == null,
                              onSelected: (selected) {
                                _onCategorySelected('');
                              },
                              backgroundColor: Colors.grey[200],
                              selectedColor: Colors.blue,
                              labelStyle: TextStyle(
                                color: _selectedCategory == null
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          // Category chips
                          ..._categories.map(
                            (category) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CategoryFilterChip(
                                category: category,
                                isSelected: _selectedCategory == category,
                                onSelected: (_) =>
                                    _onCategorySelected(category),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 16),

            // Destinations List
            Expanded(
              child: BlocBuilder<DestinationBloc, DestinationState>(
                builder: (context, state) {
                  if (state is DestinationLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is DestinationLoaded) {
                    if (state.destinations.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 60,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Không tìm thấy điểm đến nào',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.destinations.length,
                      itemBuilder: (context, index) {
                        final destination = state.destinations[index];
                        return DestinationCard(
                          destination: destination,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DestinationDetailPage(
                                  destination: destination,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is DestinationError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Có lỗi xảy ra',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              _destinationBloc
                                  .add(const FetchAllDestinations());
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
