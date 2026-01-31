class Activity {
  final String icon;
  final String title;
  final String start;
  final String end;

  Activity({
    required this.icon,
    required this.title,
    required this.start,
    required this.end,
  });
}

class DayItinerary {
  final String day;
  final List<Activity> activities;

  DayItinerary({
    required this.day,
    required this.activities,
  });
}