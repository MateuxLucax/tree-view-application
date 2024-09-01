import 'package:flutter/material.dart';

import 'pages/company_page.dart';

class TreeViewApplication extends StatelessWidget {
  const TreeViewApplication({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
        title: 'Tree View Application',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: const CompanyPage(),
      );
}
