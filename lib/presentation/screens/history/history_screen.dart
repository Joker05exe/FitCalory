import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../bloc/dashboard/dashboard_barrel.dart';
import '../../widgets/history/calendar_widget.dart';
import '../../widgets/history/weekly_chart_widget.dart';
import '../../widgets/history/daily_summary_card.dart';
import '../../../core/di/injection_container.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()
        ..add(LoadDailySummary(_selectedDate)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Calendar section
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMonthNavigation(),
                    const SizedBox(height: 16),
                    CalendarWidget(
                      selectedDate: _selectedDate,
                      focusedMonth: _focusedMonth,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                        context.read<DashboardBloc>().add(
                              LoadDailySummary(date),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Weekly trend chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WeeklyChartWidget(
                selectedDate: _selectedDate,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Daily summary for selected date
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                if (state is DashboardError) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error al cargar datos',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                if (state is DashboardLoaded) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: DailySummaryCard(summary: state.summary),
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _focusedMonth = DateTime(
                _focusedMonth.year,
                _focusedMonth.month - 1,
              );
            });
          },
        ),
        Text(
          DateFormat('MMMM yyyy', 'es').format(_focusedMonth),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            final nextMonth = DateTime(
              _focusedMonth.year,
              _focusedMonth.month + 1,
            );
            // Don't allow navigating to future months
            if (nextMonth.isBefore(DateTime.now()) ||
                nextMonth.month == DateTime.now().month) {
              setState(() {
                _focusedMonth = nextMonth;
              });
            }
          },
        ),
      ],
    );
  }
}
