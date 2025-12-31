import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/calendar_provider.dart';

class MemberCalendarWidget extends ConsumerStatefulWidget {
  const MemberCalendarWidget({super.key});

  @override
  ConsumerState<MemberCalendarWidget> createState() =>
      _MemberCalendarWidgetState();
}

class _MemberCalendarWidgetState extends ConsumerState<MemberCalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<CalendarEvent> _getEventsForDay(
    DateTime day,
    List<CalendarEvent> allEvents,
  ) {
    return allEvents.where((event) => isSameDay(event.dateTime, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(calendarProvider);
    final selectedEvents = _getEventsForDay(_selectedDay!, events);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.2),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CALENDRIER',
                style: GoogleFonts.oswald(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  DateFormat.yMMMM('fr_FR').format(_focusedDay).toUpperCase(),
                  style: GoogleFonts.inter(
                    color: AppColors.brandOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TableCalendar<CalendarEvent>(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.week,
            headerVisible: false,
            eventLoader: (day) => _getEventsForDay(day, events),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: GoogleFonts.inter(
                color: isDark ? Colors.white : Colors.black87,
              ),
              weekendTextStyle: GoogleFonts.inter(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              selectedDecoration: BoxDecoration(
                gradient: AppColors.fieryGradient,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.brandOrange.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.brandYellow,
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: GoogleFonts.inter(
                color: isDark ? Colors.grey[600] : Colors.grey[700],
                fontSize: 12,
              ),
              weekendStyle: GoogleFonts.inter(
                color: isDark ? Colors.grey[600] : Colors.grey[700],
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'ÉVÉNEMENTS DU JOUR',
            style: GoogleFonts.oswald(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          if (selectedEvents.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Aucun événement prévu pour ce jour',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.grey[600] : Colors.grey[500],
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedEvents.length,
              itemBuilder: (context, index) {
                final event = selectedEvents[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      left: BorderSide(
                        color: _getEventColor(event.type),
                        width: 4,
                      ),
                      top: BorderSide(
                        color: isDark ? Colors.transparent : Colors.grey[200]!,
                      ),
                      right: BorderSide(
                        color: isDark ? Colors.transparent : Colors.grey[200]!,
                      ),
                      bottom: BorderSide(
                        color: isDark ? Colors.transparent : Colors.grey[200]!,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      event.title,
                      style: GoogleFonts.oswald(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          event.description,
                          style: GoogleFonts.inter(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppColors.brandOrange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat.Hm().format(event.dateTime),
                              style: GoogleFonts.inter(
                                color: AppColors.brandOrange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (event.location != null) ...[
                              const SizedBox(width: 16),
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                event.location!,
                                style: GoogleFonts.inter(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'session':
        return Colors.blue;
      case 'workshop':
        return Colors.purple;
      case 'event':
        return AppColors.brandOrange;
      default:
        return Colors.grey;
    }
  }
}
