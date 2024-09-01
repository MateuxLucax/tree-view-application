class Location {
  Location({
    required this.id,
    required this.name,
    this.parentId,
  });

  // ignore: always_specify_types
  factory Location.fromJson(final json) => Location(
        id: json['id'],
        name: json['name'],
        parentId: json['parentId'],
      );

  final String id;
  final String name;
  final String? parentId;
}
