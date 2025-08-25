import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/appointment/hospital_booking_page.dart';
import 'package:obaatanpa_mobile/screens/dashboard/health%20practitioner/components/analytics_overview_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/health%20practitioner/components/appointment_overview_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/health%20practitioner/components/patient_list_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/health%20practitioner/components/practitioner_profile_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/health%20practitioner/components/resource_contribution_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/health%20practitioner/health_practitioner_dashboard.dart';
import 'package:obaatanpa_mobile/screens/dashboard/hospital/analytics/analytics_summary_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/hospital/hospital_dashboard.dart';
import 'package:obaatanpa_mobile/screens/dashboard/hospital/patients/patient_list_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/hospital/profile/hospital_profile_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/hospital/resources/resource_management_card.dart';
import 'package:obaatanpa_mobile/screens/dashboard/new mother/new_mother_dashboard.dart';
import 'package:obaatanpa_mobile/screens/dashboard/new%20mother/appointment/new_mother_appointments_page.dart';
import 'package:obaatanpa_mobile/screens/dashboard/new%20mother/resources/new_mother_resources_page.dart';
import 'package:obaatanpa_mobile/screens/splash_screen.dart';

// Screen imports
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/onboarding_screen.dart'; // Add this import for your onboarding screen
import '../screens/dashboard/pregnant mother/pregnant_mother_dashboard.dart';
import '../screens/test/test_dashboard_screen.dart';

// ✅ Import your existing screens
import '../screens/dashboard/pregnant mother/appointment/appointment_screen.dart';
import '../screens/dashboard/pregnant mother/resources/resources_page.dart';
import '../screens/dashboard/pregnant mother/nutrition/nutrition_screen.dart';
import '../screens/dashboard/pregnant mother/health/health_screen.dart';

// Notification Page Import
import '../screens/dashboard/notification_page.dart';

// Resources
import '../screens/dashboard/new mother/resources/baby_care_page.dart';
import '../screens/dashboard/new mother/resources/breastfeeding_page.dart';
import '../screens/dashboard/new mother/resources/mental_health_page.dart';

// Appointments

// Nutrition
import '../screens/dashboard/new mother/nutrition/new_mother_nutrition_page.dart';

// Health
import '../screens/dashboard/new mother/health/new_mother_health_page.dart';

// ✅ Hospital Screen Imports
import '../screens/dashboard/hospital/practitioners/hospital_practitioners_page.dart';
import '../screens/dashboard/hospital/appointments/hospital_appointments_page.dart';

// ✅ Health Practitioner Screen Imports

/// App Router - Navigation configuration for the app
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // Start with splash screen
    routes: [
      // ============================================
      // SPLASH & ONBOARDING ROUTES
      // ============================================
      
      // Splash Screen - Initial route
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Onboarding Screen - For new users
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // ============================================
      // AUTH ROUTES
      // ============================================
      
      GoRoute(
        path: '/auth/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ============================================
      // NOTIFICATION ROUTE
      // ============================================
      
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationPage(),
      ),

      // ============================================
      // PREGNANT MOTHER ROUTES (existing)
      // ============================================
      
      GoRoute(
        path: '/appointments',
        name: 'appointments',
        builder: (context, state) => AppointmentsScreen(),
      ),
      GoRoute(
        path: '/resources',
        name: 'resources',
        builder: (context, state) => const ResourcesScreen(),
      ),
      GoRoute(
        path: '/nutrition',
        name: 'nutrition',
        builder: (context, state) => const NutritionScreen(),
      ),
      GoRoute(
        path: '/health',
        name: 'health',
        builder: (context, state) => const HealthScreen(),
      ),

      // Hospital booking
      GoRoute(
        path: '/hospital-booking',
        name: 'hospital-booking',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return HospitalBookingPage(
            hospitalName: extra['hospitalName']!,
            hospitalAddress: extra['hospitalAddress']!,
            hospitalImage: extra['hospitalImage']!,
            phoneNumber: extra['phoneNumber']!,
          );
        },
      ),

      // Dashboard Routes
      GoRoute(
        path: '/dashboard/pregnant-mother',
        name: 'pregnant-dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/test/pregnant-dashboard',
        name: 'test-pregnant-dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/test/dashboard',
        name: 'test-dashboard',
        builder: (context, state) => const TestDashboardScreen(),
      ),

      // ============================================
      // HEALTH PRACTITIONER ROUTES
      // ============================================
      
      // Health Practitioner Dashboard - Main Dashboard
      GoRoute(
        path: '/practitioner/dashboard',
        name: 'practitioner-dashboard',
        builder: (context, state) => const HealthPractitionerDashboardPage(),
      ),

      // Health Practitioner Appointments Management
      GoRoute(
        path: '/practitioner/appointments',
        name: 'practitioner-appointments',
        builder: (context, state) => const PractitionerAppointmentsPage(),
      ),

      // Health Practitioner Patients Management
      GoRoute(
        path: '/practitioner/patients',
        name: 'practitioner-patients',
        builder: (context, state) => const PractitionerPatientsPage(),
      ),

      // Health Practitioner Resources Management
      GoRoute(
        path: '/practitioner/resources',
        name: 'practitioner-resources',
        builder: (context, state) => const PractitionerResourcesPage(),
      ),

      // Health Practitioner Analytics
      GoRoute(
        path: '/practitioner/analytics',
        name: 'practitioner-analytics',
        builder: (context, state) => const PractitionerAnalyticsPage(),
      ),

      // Health Practitioner Profile Management
      GoRoute(
        path: '/practitioner/profile',
        name: 'practitioner-profile',
        builder: (context, state) => const PractitionerProfilePage(),
      ),

      // ============================================
      // HOSPITAL ROUTES
      // ============================================
      
      // Hospital Dashboard - Main Dashboard
      GoRoute(
        path: '/hospital/dashboard',
        name: 'hospital-dashboard',
        builder: (context, state) => const HospitalDashboardPage(),
      ),

      // Hospital Practitioners Management
      GoRoute(
        path: '/hospital/practitioners',
        name: 'hospital-practitioners',
        builder: (context, state) => const HospitalPractitionersPage(),
      ),

      // Hospital Appointments Management
      GoRoute(
        path: '/hospital/appointments',
        name: 'hospital-appointments',
        builder: (context, state) => const HospitalAppointmentsPage(),
      ),

      // Hospital Patients Management
      GoRoute(
        path: '/hospital/patients',
        name: 'hospital-patients',
        builder: (context, state) => const HospitalPatientsPage(),
      ),

      // Hospital Resources Management
      GoRoute(
        path: '/hospital/resources',
        name: 'hospital-resources',
        builder: (context, state) => const HospitalResourcesPage(),
      ),

      // Hospital Analytics
      GoRoute(
        path: '/hospital/analytics',
        name: 'hospital-analytics',
        builder: (context, state) => const HospitalAnalyticsPage(),
      ),

      // Hospital Profile Management
      GoRoute(
        path: '/hospital/profile',
        name: 'hospital-profile',
        builder: (context, state) => const HospitalProfilePage(),
      ),

      // ============================================
      // NEW MOTHER ROUTES
      // ============================================
      
      // New Mother Dashboard - KEEP THIS ONE
      GoRoute(
        path: '/new-mother/dashboard',
        name: 'new-mother-dashboard',
        builder: (context, state) => const NewMotherDashboardPage(),
      ),

      // New Mother Resources
      GoRoute(
        path: '/new-mother/resources',
        name: 'new-mother-resources',
        builder: (context, state) => const NewMotherResourcesPage(),
      ),
      GoRoute(
        path: '/new-mother/resources/baby-care',
        name: 'new-mother-baby-care',
        builder: (context, state) => const BabyCareePage(),
      ),
      GoRoute(
        path: '/new-mother/resources/breastfeeding',
        name: 'new-mother-breastfeeding-resources',
        builder: (context, state) => const BreastfeedingPage(),
      ),
      GoRoute(
        path: '/new-mother/resources/mental-health',
        name: 'new-mother-mental-health-resources',
        builder: (context, state) => const MentalHealthPage(),
      ),

      // New Mother Appointments
      GoRoute(
        path: '/new-mother/appointments',
        name: 'new-mother-appointments',
        builder: (context, state) => const NewMotherAppointmentsPage(),
      ),

      // New Mother Nutrition
      GoRoute(
        path: '/new-mother/nutrition',
        name: 'new-mother-nutrition',
        builder: (context, state) => const NewMotherNutritionPage(),
      ),

      // New Mother Health
      GoRoute(
        path: '/new-mother/health',
        name: 'new-mother-health',
        builder: (context, state) => const NewMotherHealthPage(),
      ),

      // Legacy routes (keeping for backward compatibility)
      GoRoute(
        path: '/baby-care',
        builder: (context, state) => const BabyCareePage(),
      ),
      GoRoute(
        path: '/breastfeeding',
        builder: (context, state) => const BreastfeedingPage(),
      ),
      GoRoute(
        path: '/mental-health',
        builder: (context, state) => const MentalHealthPage(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: const Center(
        child: Text('Page not found'),
      ),
    ),
  );
}