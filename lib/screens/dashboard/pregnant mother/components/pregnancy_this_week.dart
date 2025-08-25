import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/pregnancy_data_provider.dart';

// Personalized Pregnancy Week Card
class PersonalizedPregnancyWeekCard extends StatelessWidget {
  final int currentWeek;
  final String trimester;
  final int daysUntilDue;
  final String pregnancyPhase;
  final VoidCallback? onJournalTap; // Add callback for journal

  const PersonalizedPregnancyWeekCard({
    Key? key,
    required this.currentWeek,
    required this.trimester,
    required this.daysUntilDue,
    required this.pregnancyPhase,
    this.onJournalTap, // Optional callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFCB5B5), // Lighter version of F59297
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with green dot and pregnancy week
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$pregnancyPhase Week',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Main week number
          Text(
            '$currentWeek Weeks',
            style: const TextStyle(
              color: Color(0xFFF59297), // Changed to F59297
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Days until due
          Text(
            '$daysUntilDue days',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          
          // Trimester info with progress
          Row(
            children: [
              Text(
                '$trimester - ${((currentWeek / 40.0) * 100).round()}% Complete',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          
          // Progress bar
          Row(
            children: [
              Text(
                'Week 1',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: currentWeek / 40.0, // Progress based on current week out of 40
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF7DA8E6), // Blue
                            Color(0xFFF59297), // Pink
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Week 40',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Journal Entry button - UPDATED
          GestureDetector(
            onTap: onJournalTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF8BBD9), Color(0xFFF59297)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF8BBD9).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.book_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Add Week $currentWeek Entry",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Bottom section with fetus image and info circles
          Row(
            children: [
              // Fetus illustration from assets with fallback - Made bigger
              Container(
                width: 150, // Increased from 120
                height: 150, // Increased from 120
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/dashboard/baby-development.png', 
                    width: 150, // Increased from 120
                    height: 150, // Increased from 120
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Info circles in 2x2 grid
              Expanded(
                child: Column(
                  children: [
                    // Top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Size info
                        Container(
                          width: 45, // Decreased from 60
                          height: 45, // Decreased from 60
                          decoration: const BoxDecoration(
                            color: Color(0xFFE1BEE7), // Purple circle
                            shape: BoxShape.circle,
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '45cm',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10, // Decreased from 12
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Weight info
                        Container(
                          width: 45, // Decreased from 60
                          height: 45, // Decreased from 60
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF59D), // Yellow circle
                            shape: BoxShape.circle,
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '2.5 kg',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10, // Decreased from 12
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Bottom row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Heart rate
                        Container(
                          width: 45, // Decreased from 60
                          height: 45, // Decreased from 60
                          decoration: const BoxDecoration(
                            color: Color(0xFFA5D6A7), // Green circle
                            shape: BoxShape.circle,
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '130',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12, // Kept same as it was already good
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'bpm',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 7, // Decreased from 8
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Happy indicator
                        Container(
                          width: 45, // Decreased from 60
                          height: 45, // Decreased from 60
                          decoration: const BoxDecoration(
                            color: Color(0xFF81D4FA), // Light blue circle
                            shape: BoxShape.circle,
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Happy',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 9, // Decreased from 10
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}