import 'package:flutter/material.dart';

class SearchPanelWidget extends StatefulWidget {
  const SearchPanelWidget({
    required this.onSearch,
    super.key,
  });

  final void Function(
    String query, {
    required bool energySensor,
    required bool criticalStatus,
  }) onSearch;

  @override
  State<SearchPanelWidget> createState() => _SearchPanelWidgetState();
}

class _SearchPanelWidgetState extends State<SearchPanelWidget> {
  final TextEditingController controller = TextEditingController();
  bool isEnergySensorActive = false;
  bool isWarningActive = false;

  void handleSearch(final String query) {
    widget.onSearch(
      query,
      energySensor: isEnergySensorActive,
      criticalStatus: isWarningActive,
    );
  }

  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: handleSearch,
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    isEnergySensorActive = !isEnergySensorActive;
                  });
                  handleSearch(controller.text);
                },
                icon: const Icon(Icons.battery_std),
                label: const Text('Energy sensor'),
                style: TextButton.styleFrom(
                  backgroundColor: isEnergySensorActive
                      ? Colors.blueAccent.withOpacity(0.1)
                      : Colors.transparent,
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    isWarningActive = !isWarningActive;
                  });
                  handleSearch(controller.text);
                },
                icon: const Icon(Icons.error),
                label: const Text('Critical'),
                style: TextButton.styleFrom(
                  backgroundColor: isWarningActive
                      ? Colors.blueAccent.withOpacity(0.1)
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      );
}
