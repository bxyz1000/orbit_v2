import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/home/presentation/orbit_score_page.dart';
import '../features/home/presentation/orbit_feature_hub_page.dart';
import '../features/health/presentation/orbit_steps_page.dart';
import '../features/ai/presentation/orbit_ai_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../shared/widgets/orbit_bottom_nav.dart';
import '../shared/widgets/orbit_page_indicator.dart';
import '../features/health/presentation/providers/health_providers.dart';
import '../features/integrations/strava/presentation/providers/strava_providers.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> with WidgetsBindingObserver {
  late PageController _pageController;
  int _currentPage = 1; // 0=Feature Hub, 1=Score (Default), 2=Steps
  int _bottomNavIndex = 0; // 0=Home, 1=AI, 2=Profile
  Timer? _healthSyncTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initial page set to 1 (CENTER - Score Home)
    _pageController = PageController(initialPage: 1);

    _refreshHealth();
    _startPeriodicHealthSync();

    // Initialize Strava Auth listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(stravaAuthNotifierProvider);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _healthSyncTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _startPeriodicHealthSync() {
    _healthSyncTimer?.cancel();
    _healthSyncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      debugPrint('[HEALTH] OrbitHome: Periodic 30s sync check triggered');
      ref.read(healthSyncNotifierProvider.notifier).sync();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshHealth();
    }
  }

  Future<void> _refreshHealth() async {
    debugPrint('[HEALTH] OrbitHome: Refreshing health data on resume/init');
    await ref.read(healthSyncNotifierProvider.notifier).sync();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      if (index == 1) {
        _bottomNavIndex = 0; // Home is selected when on center page
      }
    });
  }

  void _onBottomNavTap(int index) {
    if (index == 0) {
      // Home -> Jump/Animate to Center page (Score)
      setState(() => _bottomNavIndex = 0);
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else if (index == 1) {
      // AI Assistant -> Push AI screen
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const OrbitAiPage()),
      );
    } else if (index == 2) {
      // Profile -> Push Profile + Settings screen
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ─── 3 Horizontal Pages (FEATURE HUB ← SCORE → STEPS) ───
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            children: [
              OrbitFeatureHubPage(
                onNavigateToSteps: () {
                  _pageController.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                  );
                },
              ),
              const OrbitScorePage(),
              const OrbitStepsPage(),
            ],
          ),

          // ─── Floating Bottom Navigation + Page Indicator ───
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dots page indicator
                OrbitPageIndicator(
                  pageCount: 3,
                  currentPage: _currentPage,
                ),
                const SizedBox(height: 12),

                // Floating 3-pill bottom nav
                OrbitBottomNav(
                  currentIndex: _bottomNavIndex,
                  onTap: _onBottomNavTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
