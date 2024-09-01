import 'dart:async';

import 'package:flutter/material.dart';

import '../controller/company_controller.dart';
import '../model/company.dart';
import '../state/company_state.dart';
import 'tree_page.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  final CompanyController controller = CompanyController();

  void handleStateChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    unawaited(controller.fetchCompanies());
    controller.addListener(handleStateChange);
  }

  void onCompanyTap(final Company company) {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<TreePage>(
          builder: (final BuildContext context) => TreePage(
            company: company,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CompanyState state = controller.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: switch (state) {
        CompanyLoaded() => ListView(
            children: state.companies
                .map<Widget>(
                  (final Company company) => ListTile(
                    title: Text(company.name),
                    onTap: () {
                      onCompanyTap(company);
                    },
                  ),
                )
                .toList(),
          ),
        CompanyError() => Column(
            children: <Widget>[
              Text(state.message),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: controller.fetchCompanies,
                child: const Text('Retry'),
              ),
            ],
          ),
        _ => const Center(
            child: CircularProgressIndicator(),
          ),
      },
    );
  }
}
