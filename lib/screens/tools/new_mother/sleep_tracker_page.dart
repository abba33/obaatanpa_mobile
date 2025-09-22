import 'package:flutter/material.dart';

class SleepTrackerPage extends StatefulWidget {
  const SleepTrackerPage({Key? key}) : super(key: key);

  @override
  State<SleepTrackerPage> createState() => _SleepTrackerPageState();
}

class _SleepTrackerPageState extends State<SleepTrackerPage> {
  final List<SleepLog> _sleepLogs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Tracker'),
        backgroundColor: const Color(0xFF9B59B6),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSleepSummary(),
            const SizedBox(height: 24),
            _buildLogButton(),
            const SizedBox(height: 24),
            _buildSleepTips(),
            const SizedBox(height: 24),
            _buildSleepLogs(),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepSummary() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sleep Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9B59B6),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat('Hours Today', '6.5'),
                _buildSummaryStat('Quality', '7/10'),
                _buildSummaryStat('Sessions', '3'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9B59B6),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLogButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Log Sleep Session'),
        onPressed: _showLogSleepDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9B59B6),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSleepTips() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Sleep Tips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9B59B6),
              ),
            ),
            SizedBox(height: 16),
            Text('• Sleep when your baby sleeps'),
            Text('• Keep the room dark and quiet'),
            Text('• Accept help from family and friends'),
            Text('• Establish a bedtime routine'),
            Text('• Avoid screens before bedtime'),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepLogs() {
    if (_sleepLogs.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No sleep logs yet. Start tracking your sleep patterns.'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sleep History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9B59B6),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _sleepLogs.length,
          itemBuilder: (context, index) {
            final log = _sleepLogs[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.bedtime, color: Color(0xFF9B59B6)),
                title: Text('${log.duration} hours'),
                subtitle: Text('Quality: ${log.quality}/10\n${log.date}'),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showLogSleepDialog() {
    // TODO: Implement sleep log dialog
    // This would show a dialog to input sleep details
    // like duration, quality rating, and time
  }
}

class SleepLog {
  final double duration;
  final int quality;
  final DateTime date;

  SleepLog({
    required this.duration,
    required this.quality,
    required this.date,
  });
}
