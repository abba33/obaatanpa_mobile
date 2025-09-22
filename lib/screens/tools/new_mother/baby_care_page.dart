import 'package:flutter/material.dart';

class BabyCarePage extends StatefulWidget {
  const BabyCarePage({Key? key}) : super(key: key);

  @override
  State<BabyCarePage> createState() => _BabyCarePageState();
}

class _BabyCarePageState extends State<BabyCarePage> {
  final List<FeedingLog> _feedingLogs = [];
  final List<DiaperLog> _diaperLogs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby Care'),
        backgroundColor: const Color(0xFF9B59B6),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTrackingButtons(),
            const SizedBox(height: 24),
            _buildSectionTitle('Recent Feeding Logs'),
            _buildFeedingLogs(),
            const SizedBox(height: 24),
            _buildSectionTitle('Recent Diaper Changes'),
            _buildDiaperLogs(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.restaurant),
            label: const Text('Log Feeding'),
            onPressed: () => _showFeedingDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9B59B6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.baby_changing_station),
            label: const Text('Log Diaper'),
            onPressed: () => _showDiaperDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9B59B6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9B59B6),
        ),
      ),
    );
  }

  Widget _buildFeedingLogs() {
    if (_feedingLogs.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No feeding logs yet. Start tracking by tapping "Log Feeding"'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _feedingLogs.length,
      itemBuilder: (context, index) {
        final log = _feedingLogs[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.restaurant, color: Color(0xFF9B59B6)),
            title: Text(log.type),
            subtitle: Text('${log.amount} - ${log.time.toString()}'),
          ),
        );
      },
    );
  }

  Widget _buildDiaperLogs() {
    if (_diaperLogs.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No diaper logs yet. Start tracking by tapping "Log Diaper"'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _diaperLogs.length,
      itemBuilder: (context, index) {
        final log = _diaperLogs[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.baby_changing_station, color: Color(0xFF9B59B6)),
            title: Text(log.type),
            subtitle: Text(log.time.toString()),
          ),
        );
      },
    );
  }

  void _showFeedingDialog() {
    // TODO: Implement feeding log dialog
    // This would show a dialog to input feeding details
    // like type (breast, bottle), amount, and time
  }

  void _showDiaperDialog() {
    // TODO: Implement diaper log dialog
    // This would show a dialog to input diaper change details
    // like type (wet, dirty) and time
  }
}

class FeedingLog {
  final String type;
  final String amount;
  final DateTime time;

  FeedingLog({
    required this.type,
    required this.amount,
    required this.time,
  });
}

class DiaperLog {
  final String type;
  final DateTime time;

  DiaperLog({
    required this.type,
    required this.time,
  });
}
