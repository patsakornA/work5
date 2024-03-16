class Game {
  final int id;
  final String name;
  final List<String> genre;
  final List<String> developers;
  final List<String> publishers;
  final Map<String, String> releaseDates;

  Game({
    required this.id,
    required this.name,
    required this.genre,
    required this.developers,
    required this.publishers,
    required this.releaseDates,
  });
}
