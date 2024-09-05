class FilterParams {
  FilterParams({
    required this.query,
    required this.energySensor,
    required this.criticalStatus,
  });

  factory FilterParams.empty() => FilterParams(
        query: '',
        energySensor: false,
        criticalStatus: false,
      );

  final String query;
  final bool energySensor;
  final bool criticalStatus;
}
