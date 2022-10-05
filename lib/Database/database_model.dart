final String tableMovie = 'news';

class MovieFields {
  static final List<String> values = [
    id, imagePath, name, idMovie
  ];
  static final String id = '_id';
  static final String imagePath = 'img';
  static final String name = 'name';
  static final String idMovie = 'date';
}

class MovieModel {
  final int? id;
  final String imagePath;
  final String name;
  final String idMovie;

  MovieModel(
      {this.id,
        required this.imagePath,
        required this.name,
        required this.idMovie});

  static MovieModel fromJson(Map<String, Object?> json) => MovieModel(
      id: json[MovieFields.id] as int?,
      idMovie: json[MovieFields.idMovie] as String,
      name: json[MovieFields.name] as String,
      imagePath: json[MovieFields.imagePath] as String
  );

  Map<String, Object?> toJson() => {
    MovieFields.id: id,
    MovieFields.idMovie: idMovie,
    MovieFields.name: name,
    MovieFields.imagePath: imagePath
  };
  MovieModel copy({int? id, String? title, String? author, String? imageUrl}) =>
      MovieModel(
          id: id ?? this.id,
          idMovie: title ?? this.idMovie,
          name: author ?? this.name,
          imagePath: imageUrl ?? this.imagePath);
}
