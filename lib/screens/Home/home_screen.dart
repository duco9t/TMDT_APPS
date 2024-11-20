import 'package:HDTech/models/tshirt_model.dart';
import 'package:HDTech/screens/Home/Widget/banner_app_bar.dart';
import 'package:HDTech/screens/Home/Widget/filter_drawer.dart';
import 'package:HDTech/screens/Home/Widget/home_app_bar.dart';
import 'package:HDTech/screens/Home/Widget/popular_tshirt_bar.dart';
import 'package:HDTech/screens/Home/Widget/trademark_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure this import is present

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> filters = {}; // Store filters here
  List<Tshirt> _tshirts = []; // Store filtered tshirts
  List<String> bannerUrls = [];
  bool _isRefreshing = false;
  bool _enableLocationServices = false; // Added missing field

  final GlobalKey<PopularTshirtBarState> popularTshirtBarKey =
      GlobalKey<PopularTshirtBarState>();

  @override
  void initState() {
    super.initState();
    _initializeSettings();
    _fetchBannerUrls();
    _fetchTshirts(); // Fetch all tshirts initially without filters
    _refreshData();
  }

  // Initialize settings and location services
  Future<void> _initializeSettings() async {
    await _loadLocationSetting();
  }

  Future<void> _loadLocationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enableLocationServices = prefs.getBool('locationServices') ?? false;
    });
  }

  // Hàm tải URL banner
  Future<void> _fetchBannerUrls() async {
    final List<Tshirt> tshirts = await loadTshirts();
    setState(() {
      bannerUrls = tshirts
          .where((tshirt) => tshirt.bannerUrl != null)
          .map((tshirt) => tshirt.bannerUrl!)
          .toList();
    });
  }

  // Hàm làm mới dữ liệu
  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    await Future.delayed(const Duration(seconds: 2)); // Giả lập làm mới dữ liệu
    _fetchTshirts(); // Re-fetch all tshirts without filters
    popularTshirtBarKey.currentState
        ?.reloadTshirts(); // Reload lại thông tin máy tính
    setState(() {
      _isRefreshing = false;
    });
  }

  // Handle filter changes and update the tshirt list
  void _onFilterChanged(Map<String, dynamic> filters) {
    _fetchTshirts(
        filters: filters); // Fetch tshirts with the applied filters
    _refreshData(); // Automatically reload after applying the filters
  }

  Future<void> _fetchTshirts({Map<String, dynamic>? filters}) async {
    // Tải tất cả sản phẩm (có thể lấy từ API hoặc dữ liệu tĩnh)
    List<Tshirt> allTshirts = await loadTshirts();

    // Lọc theo các bộ lọc nếu filters có chứa giá trị
    if (filters != null) {
      if (filters['brand'] != null && filters['brand'] != 'All') {
        // Lọc theo thương hiệu
        allTshirts = allTshirts
            .where((tshirt) => tshirt.brand == filters['brand'])
            .toList();
      }

      if (filters['size'] != null && filters['size'] != 'All') {
        // Lọc theo size
        allTshirts = allTshirts
            .where((tshirt) => tshirt.size == filters['size'])
            .toList();
      }

      if (filters['color'] != null && filters['color'] != 'All') {
        // Lọc theo color
        allTshirts = allTshirts
            .where((tshirt) => tshirt.color == filters['color'])
            .toList();
      }

      if (filters['gender'] != null && filters['gender'] != 'All') {
        // Lọc theo Gender
        allTshirts = allTshirts
            .where((tshirt) => tshirt.gender == filters['gender'])
            .toList();
      }
    }

    // Cập nhật danh sách máy tính sau khi lọc
    setState(() {
      _tshirts = allTshirts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      drawer: FilterDrawer(
        tshirts: _tshirts.isEmpty
            ? []
            : _tshirts, // Pass the tshirts list (empty if no products are fetched yet)
        onFilterChanged: (filters) {
          _onFilterChanged(filters); // Handle the filter changes here
        },
      ),
      body: Builder(
        builder: (context) => RefreshIndicator(
          onRefresh: _refreshData, // Khi kéo xuống để làm mới
          child: CustomScrollView(
            slivers: [
              // AppBar tùy chỉnh với bộ lọc
              SliverAppBar(
                backgroundColor: const Color.fromARGB(255, 241, 241, 241),
                elevation: 0,
                title: CustomAppBar(
                  onFilterChanged: _onFilterChanged,
                  enableLocationServices:
                      _enableLocationServices, // Pass the value here
                ),
                automaticallyImplyLeading: false,
                pinned: true,
                floating: false,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return AnimationLimiter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 500),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(child: widget),
                            ),
                            children: [
                              BannerAppBar(
                                  bannerUrls: bannerUrls), // Hiển thị banner
                              const SizedBox(height: 10),
                              TrademarkAppBar(
                                onCompanySelected: (String brand) {
                                  // Gọi hàm lọc khi chọn thương hiệu
                                  _onFilterChanged({'brand': brand});
                                },
                              ), // Hiển thị thương hiệu
                              const SizedBox(height: 10),
                              PopularTshirtBar(
                                key: popularTshirtBarKey,
                                tshirts:
                                    _tshirts, // Ensure this list is updated
                                filters: filters,
                                isRefreshing:
                                    _isRefreshing, // Pass the refresh state
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
