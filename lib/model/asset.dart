class Asset {
  Asset({
    required this.id,
    required this.name,
    this.parentId,
    this.locationId,
    this.sensorType,
    this.status,
  });

  // ignore: always_specify_types
  factory Asset.fromJson(final json) => Asset(
        id: json['id'],
        name: json['name'],
        parentId: json['parentId'],
        locationId: json['locationId'],
        sensorType: json['sensorType'],
        status: json['status'],
      );

  // TODO: use pattern matching for json validation

  final String id;
  final String name;
  final String? parentId;
  final String? locationId;
  final String? sensorType;
  final String? status;
}
