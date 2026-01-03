import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/providers/auth_provider.dart';
import '../../presentation/screens/auth/onboarding_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/web/web_landing_page.dart';
import '../../presentation/screens/web/web_branch_details_page.dart';
import '../../presentation/screens/web/web_branches_page.dart';
import '../../presentation/screens/web/web_pricing_page.dart';
import '../../presentation/screens/web/web_blog_page.dart';
import '../../presentation/screens/web/web_contact_page.dart';
import '../../presentation/screens/web/web_workouts_page.dart';
import '../../presentation/screens/web/web_challenges_page.dart';
import '../../presentation/screens/mobile/mobile_contact_page.dart';
import '../../presentation/screens/web/web_partners_page.dart';
import '../../presentation/screens/web/web_programs_page.dart';
import '../../presentation/screens/member/member_dashboard_screen.dart';
import '../../presentation/screens/member/programs/programs_list_screen.dart';
import '../../presentation/screens/member/programs/program_detail_screen.dart'; // Added import
import '../../data/models/program_model.dart'; // Added import

import '../../presentation/screens/member/booking/booking_calendar_screen.dart';
import '../../presentation/screens/member/booking/my_bookings_screen.dart';
import '../../presentation/screens/member/profile/profile_screen.dart';
import '../../presentation/screens/member/profile/settings_screen.dart';
import '../../presentation/screens/member/profile/stats_screen.dart';
import '../../presentation/screens/member/profile/subscription_screen.dart';
import '../../presentation/screens/member/social/feed_screen.dart';
import '../../presentation/screens/member/social/messages_screen.dart';
import '../../presentation/screens/member/social/sparring_partner_screen.dart';
import '../../presentation/screens/admin/admin_dashboard_screen.dart'; // Added Admin Screen
import '../../presentation/screens/coach/coach_dashboard_screen.dart'; // Added Coach Screen

/// Route paths as constants for type-safety
class AppRoutes {
  static const webBranches = '/branches';
  static const webPricing = '/pricing';
  static const webBlog = '/blog';
  static const webContact = '/contact';
  static const webWorkouts = '/workouts';
  static const webChallenges = '/challenges';
  static const webPartners = '/partners';
  static const webPrograms = '/programs';
  static const mobileContact = '/mobile/contact';
  static const mobileBranches = '/mobile/branches';
  static const mobilePricing = '/mobile/pricing';
  static const mobileBlog = '/mobile/blog';
  static const mobileWorkouts = '/mobile/workouts';
  static const mobileChallenges = '/mobile/challenges';

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const memberDashboard = '/member';
  static const qrCode = '/member/qr-code';
  static const programs = '/member/programs';
  static const programDetail = '/member/programs/:id';
  static const booking = '/member/booking';
  static const myBookings = '/member/my-bookings';
  static const profile = '/member/profile';
  static const stats = '/member/profile/stats';
  static const subscription = '/member/profile/subscription';
  static const settings = '/member/settings';
  static const feed = '/member/feed';
  static const messages = '/member/messages';
  static const sparring = '/member/sparring';
  static const admin = '/admin'; // Admin Dashboard
  static const coach = '/coach'; // Coach Dashboard
}

/// Provider for the GoRouter instance
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: notifier, // Listens to auth changes to trigger redirect
    redirect: (context, state) {
      // Use ref.read() to get current state without triggering a rebuild of the provider
      final authState = ref.read(authNotifierProvider);
      final isAuthenticated = authState.isAuthenticated;

      final isPublicRoute =
          state.matchedLocation == AppRoutes.splash ||
          state.matchedLocation == AppRoutes.webBranches ||
          state.matchedLocation == AppRoutes.webPricing ||
          state.matchedLocation == AppRoutes.webContact ||
          state.matchedLocation == AppRoutes.webBlog ||
          state.matchedLocation == AppRoutes.webWorkouts ||
          state.matchedLocation == AppRoutes.webChallenges ||
          state.matchedLocation == AppRoutes.webPartners ||
          state.matchedLocation.startsWith('/branch-details/') ||
          state.matchedLocation == AppRoutes.mobileContact ||
          state.matchedLocation == AppRoutes.mobileBranches ||
          state.matchedLocation == AppRoutes.mobilePricing ||
          state.matchedLocation == AppRoutes.mobileBlog ||
          state.matchedLocation == AppRoutes.mobileWorkouts ||
          state.matchedLocation == AppRoutes.mobileChallenges;

      final isAuthRoute =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.onboarding;

      // Allow public routes always
      if (isPublicRoute) return null;

      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }

      // If authenticated and trying to access auth routes, redirect to appropriate dashboard
      if (isAuthenticated && isAuthRoute) {
        final userType = authState.user?.type;
        if (userType == 'admin') {
          return AppRoutes.admin;
        } else if (userType == 'coach') {
          return AppRoutes.coach;
        }
        return AppRoutes.memberDashboard;
      }

      // Role guards - prevent unauthorized access to role-specific routes
      if (isAuthenticated) {
        final userRole = authState.user?.type;

        // Admin routes - only admins allowed
        if (state.matchedLocation.startsWith('/admin') && userRole != 'admin') {
          return AppRoutes.memberDashboard;
        }

        // Coach routes - only coaches allowed
        if (state.matchedLocation.startsWith('/coach') && userRole != 'coach') {
          return AppRoutes.memberDashboard;
        }
      }

      return null;
    },
    routes: [
      // Landing / Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) {
          // On Web, show the Landing Page immediately
          // On Mobile, show splash matching native experience
          /* 
             NOTE: Typically keep Splash for initialization, but for this demo 
             we want to impress the user immediately on Web.
          */
          return const WebLandingPage();
        },
      ),

      // Web - Public Routes
      GoRoute(
        path: AppRoutes.webBranches,
        builder: (context, state) => const WebBranchesPage(),
      ),
      GoRoute(
        path: AppRoutes.webPricing,
        builder: (context, state) => const WebPricingPage(),
      ),
      GoRoute(
        path: AppRoutes.webContact,
        builder: (context, state) => const WebContactPage(),
      ),
      GoRoute(
        path: AppRoutes.webBlog,
        builder: (context, state) => const WebBlogPage(),
      ),
      GoRoute(
        path: AppRoutes.webWorkouts,
        builder: (context, state) => const WebWorkoutsPage(),
      ),
      GoRoute(
        path: AppRoutes.webChallenges,
        builder: (context, state) => const WebChallengesPage(),
      ),
      GoRoute(
        path: AppRoutes.webPartners,
        builder: (context, state) => const WebPartnersPage(),
      ),
      GoRoute(
        path: AppRoutes.webPrograms,
        builder: (context, state) => const WebProgramsPage(),
      ),

      // Mobile Routes
      GoRoute(
        path: AppRoutes.mobileContact,
        builder: (context, state) => const MobileContactPage(),
      ),
      GoRoute(
        path: AppRoutes.mobileBranches,
        builder: (context, state) =>
            const WebBranchesPage(useMobileWrapper: true),
      ),
      GoRoute(
        path: AppRoutes.mobilePricing,
        builder: (context, state) =>
            const WebPricingPage(useMobileWrapper: true),
      ),
      GoRoute(
        path: AppRoutes.mobileBlog,
        builder: (context, state) => const WebBlogPage(useMobileWrapper: true),
      ),
      GoRoute(
        path: AppRoutes.mobileWorkouts,
        builder: (context, state) =>
            const WebWorkoutsPage(useMobileWrapper: true),
      ),
      GoRoute(
        path: AppRoutes.mobileChallenges,
        builder: (context, state) =>
            const WebChallengesPage(useMobileWrapper: true),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // Member routes (protected)
      GoRoute(
        path: AppRoutes.memberDashboard,
        builder: (context, state) => const MemberDashboardScreen(),
      ),

      // Programs
      GoRoute(
        path: AppRoutes.programs,
        builder: (context, state) => const ProgramsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.programDetail,
        builder: (context, state) {
          final program = state.extra as ProgramModel;
          return ProgramDetailScreen(program: program);
        },
      ),

      // Booking
      GoRoute(
        path: AppRoutes.booking,
        builder: (context, state) => const BookingCalendarScreen(),
      ),
      GoRoute(
        path: AppRoutes.myBookings,
        builder: (context, state) => const MyBookingsScreen(),
      ),

      // Profile
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/branch-details/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return WebBranchDetailsPage(branchId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.stats,
        builder: (context, state) => const StatsScreen(),
      ),
      GoRoute(
        path: AppRoutes.subscription,
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Social
      GoRoute(
        path: AppRoutes.feed,
        builder: (context, state) => const FeedScreen(),
      ),
      GoRoute(
        path: AppRoutes.messages,
        builder: (context, state) => const MessagesScreen(),
      ),
      GoRoute(
        path: AppRoutes.sparring,
        builder: (context, state) => const SparringPartnerScreen(),
      ),

      // Admin
      GoRoute(
        path: AppRoutes.admin,
        builder: (context, state) => const AdminDashboardScreen(),
      ),

      // Coach
      GoRoute(
        path: AppRoutes.coach,
        builder: (context, state) => const CoachDashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.matchedLocation}')),
    ),
  );
});

/// A ChangeNotifier that listens to the auth provider.
/// We use this for [GoRouter.refreshListenable] to trigger redirects
/// without rebuilding the entire Router (which would reset navigation state).
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authNotifierProvider,
      (previous, next) => notifyListeners(),
    );
  }
}
