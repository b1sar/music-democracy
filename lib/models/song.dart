class Song {
  final String name;
  final String artist;
  final List<String> genres;

  Song(
    this.name,
    this.artist,
    this.genres,
  );

  String get getName {
    return this.name;
  }
}
