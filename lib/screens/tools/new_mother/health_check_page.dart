import 'package:flutter/material.dart';

class HealthCheckPage extends StatelessWidget {
  const HealthCheckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Check'),
        backgroundColor: const Color(0xFF9B59B6),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDailyCheckCard(),
            const SizedBox(height: 20),
            _buildSymptomTracker(),
            const SizedBox(height: 20),
            _buildRecoveryProgress(),
            const SizedBox(height: 20),
            _buildHealthTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyCheckCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Health Check',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9B59B6),
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Physical Activity'),
              value: false,
              onChanged: (bool? value) {},
            ),
            CheckboxListTile(
              title: const Text('Pain Assessment'),
              value: false,
              onChanged: (bool? value) {},
            ),
            CheckboxListTile(
              title: const Text('Mood Check'),
              value: false,
              onChanged: (bool? value) {},
            ),
            CheckboxListTile(
              title: const Text('Rest Period'),
              value: false,
              onChanged: (bool? value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomTracker() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Symptom Tracker',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9B59B6),
              ),
            ),
            const SizedBox(height: 16),
            _buildSymptomButton('Report Physical Symptoms', Icons.healing),
            const SizedBox(height: 8),
            _buildSymptomButton('Track Emotional Well-being', Icons.mood),
            const SizedBox(height: 8),
            _buildSymptomButton('Log Recovery Progress', Icons.trending_up),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomButton(String text, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(text),
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9B59B6),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildRecoveryProgress() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recovery Progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9B59B6),
              ),
            ),
            const SizedBox(height: 16),
            _buildProgressItem('Physical Recovery', 0.7),
            const SizedBox(height: 12),
            _buildProgressItem('Emotional Well-being', 0.8),
            const SizedBox(height: 12),
            _buildProgressItem('Energy Levels', 0.6),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9B59B6)),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildHealthTips() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Health Tips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9B59B6),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.check_circle, color: Color(0xFF9B59B6)),
              title: Text('Rest when you can'),
              subtitle: Text('Take advantage of quiet moments to rest'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Color(0xFF9B59B6)),
              title: Text('Stay hydrated'),
              subtitle: Text('Drink plenty of water throughout the day'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Color(0xFF9B59B6)),
              title: Text('Monitor your mood'),
              subtitle: Text('Be aware of your emotional well-being'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Color(0xFF9B59B6)),
              title: Text('Gentle exercise'),
              subtitle: Text('Start with light activities when approved by your doctor'),
            ),
          ],
        ),
      ),
    );
  }
}
