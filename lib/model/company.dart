class Company {
  Company({
    required this.id,
    required this.name,
  });

  // ignore: always_specify_types
  factory Company.fromJson(final json) => Company(
        id: json['id'],
        name: json['name'],
      );

  final String id;
  final String name;
}
