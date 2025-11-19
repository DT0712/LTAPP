import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../home/data/home_references.dart';
import '../../data/food_repository.dart';

import '../widgets/food_card.dart';
import '../widgets/food_appbar.dart';
import '../widgets/food_tabbar.dart';

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

      // AppBar đã tách (FoodAppBar tự import clipper trong file của nó)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170),
        child: FoodAppBar(
          tabController: _tabController,
          onBack: () => Navigator.pop(context),
          onFilter: () => _showFilterDialog(context),
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

  // ================= WIDGETS ===================

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

  // ================= FILTER DIALOG ===================

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
              const Text(
                "Chọn quận",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
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
                child: const Text(
                  "Bỏ lọc",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
