import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../home/data/home_references.dart';
import '../../data/food_repository.dart';
import '../widgets/food_card.dart';
import '../widgets/big_triangle_clipper.dart';
import '../widgets/small_triangle_clipper.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final FoodRepository _repo = FoodRepository();

  String? selectedQuan;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> _getQuery(String tab) {
    return _repo.getFoods(tab: tab, quan: selectedQuan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170),
        child: Stack(
          children: [
            ClipPath(
              clipper: BigTriangleClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFB300), Color(0xFFFFA000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: SmallTriangleClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFE082), Color(0xFFFFB300)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          "Quán ăn",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list_alt,
                              color: Colors.white),
                          onPressed: () => _showFilterDialog(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTabBar(),
                ],
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          _buildBackground(),
          Padding(
            padding: const EdgeInsets.only(top: 190),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFoodList("Gợi ý"),
                _buildFoodList("Gần tôi"),
                _buildFoodList("Giảm nhiều"),
                _buildFoodList("Mới nhất"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== WIDGETS =========================

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(50),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        labelColor: Colors.orange.shade900,
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade200.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        tabs: const [
          Tab(text: "Gợi ý"),
          Tab(text: "Gần tôi"),
          Tab(text: "Giảm nhiều"),
          Tab(text: "Mới nhất"),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFDFCFB), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildFoodList(String tab) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getQuery(tab),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Lỗi tải dữ liệu: ${snapshot.error}",
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "Không có dữ liệu",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return FoodCard(
              data: docs[index].data() as Map<String, dynamic>,
            );
          },
        );
      },
    );
  }

  // ===================== FILTER DIALOG =========================

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text("Chọn quận",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Divider(),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      HomeReferences.quanHuyenRef.orderBy('ten').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data!.docs;

                    return ListView.separated(
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;

                        final ten = HomeReferences.cleanText(
                            data['ten'] ?? docs[index].id);

                        return ListTile(
                          title: Text(ten),
                          trailing: ten == selectedQuan
                              ? const Icon(Icons.check,
                                  color: Colors.blueAccent)
                              : null,
                          onTap: () {
                            setState(() => selectedQuan = ten);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() => selectedQuan = null);
                  Navigator.pop(context);
                },
                child: const Text("Bỏ lọc",
                    style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        );
      },
    );
  }
}
