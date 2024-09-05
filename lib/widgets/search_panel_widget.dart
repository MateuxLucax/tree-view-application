import 'dart:async';

import 'package:flutter/material.dart';

import '../model/filter_params.dart';

class SearchPanelWidget extends StatefulWidget {
  const SearchPanelWidget({
    required this.onSearch,
    required this.filterParams,
    super.key,
  });

  final void Function(
    FilterParams params,
  ) onSearch;
  final FilterParams filterParams;

  @override
  State<SearchPanelWidget> createState() => _SearchPanelWidgetState();
}

class _SearchPanelWidgetState extends State<SearchPanelWidget> {
  final TextEditingController controller = TextEditingController();
  bool isEnergySensorActive = false;
  bool isWarningActive = false;

  final Debouncer debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  @override
  void initState() {
    super.initState();
    controller.text = widget.filterParams.query;
    isEnergySensorActive = widget.filterParams.energySensor;
    isWarningActive = widget.filterParams.criticalStatus;
  }

  void handleSearch(final String query) {
    widget.onSearch(
      FilterParams(
        query: query,
        energySensor: isEnergySensorActive,
        criticalStatus: isWarningActive,
      ),
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
            onChanged: (final String value) {
              debouncer.run(() {
                handleSearch(value);
              });
            },
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

class Debouncer {
  Debouncer({
    required this.duration,
  });

  final Duration duration;
  Timer? _timer;

  void run(final VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }
}
