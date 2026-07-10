import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/core/theme/app_colors.dart';
import 'package:stock_app/features/home/widgets/index_chart.dart';
import 'package:stock_app/features/home/widgets/slanted_clipper.dart';
import 'package:stock_app/features/login/login_page.dart';
import 'package:stock_app/features/login/register_page.dart';
import 'package:stock_app/providers/auth_provider.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  final PageController _pageController = PageController();

  final List<String> _images = [
    'assets/images/banner-1.jpg',
    'assets/images/banner-2.jpg',
    'assets/images/banner-3.jpg',
  ];

  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_pageController.hasClients) return;

      _currentPage++;

      if (_currentPage >= _images.length) {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );

      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: AppColors.primary,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),

                /// Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 180,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: _images.length,
                        itemBuilder: (_, index) {
                          return Image.asset(
                            _images[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: List.generate(
                      _images.length,
                      (index) {
                        final selected = index == _currentPage;

                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              left: index == 0 ? 0 : 4,
                              right: index == _images.length - 1 ? 0 : 4,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              height: 4,
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Bottom Sheet Content
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    minHeight: 600, // hoặc theo nội dung
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: _buildContentBottom(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBottom() {
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(children: [
        isLoggedIn == true ? _buidNetWorthInfo() : _buildAutherSwitcher(),
        _buildOverviewMenu(),
        const IndexChart(),
      ]),
    );
  }

  Widget _buidNetWorthInfo() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'common.netAssetValue'.tr(),
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          const SizedBox(
            width: 4,
          ),
          Text('-------', style: TextStyle(color: AppColors.primary)),
          const SizedBox(
            width: 4,
          ),
          Icon(Icons.change_circle_outlined)
        ],
      ),
    );
  }

  Widget _buildAutherSwitcher() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (_, animation, __) => const LoginPage(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ));
                  },
                  child: ClipPath(
                    clipper: SlantedClipper(isLeft: true),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4)),
                      alignment: Alignment.center,
                      child: Text(
                        'menu.login'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (_, animation, __) => const RegisterPage(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ));
                  },
                  child: ClipPath(
                    clipper: SlantedClipper(isLeft: false),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: AppColors.reference,
                          borderRadius: BorderRadius.circular(4)),
                      alignment: Alignment.center,
                      child: Text(
                        'menu.register'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildOverviewMenu() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildOverviewButton(Icons.security, 'SmartOTP'),
          ),
          Expanded(
            child: _buildOverviewButton(Icons.category, 'common.portfolio'.tr()),
          ),
          Expanded(
            child: _buildOverviewButton(
              Icons.contact_emergency,
              'common.onlineOrderConfirmation'.tr(),
            ),
          ),
          Expanded(
            child: _buildOverviewButton(Icons.add_circle, 'common.customization'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBright,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40, // đủ cho 2 dòng
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
