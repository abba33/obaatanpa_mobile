import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../dashboard/pregnant mother/pregnant_mother_dashboard.dart';

class TestDashboardScreen extends StatefulWidget {
  const TestDashboardScreen({Key? key}) : super(key: key);

  @override
  State<TestDashboardScreen> createState() => _TestDashboardScreenState();
}

class _TestDashboardScreenState extends State<TestDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-login for testing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.autoLoginForTesting();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!authProvider.isAuthenticated) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Setting up test authentication...'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => authProvider.autoLoginForTesting(),
                    child: const Text('Login as Test User'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show the dashboard once authenticated
        return const DashboardPage();
      },
    );
  }
}
