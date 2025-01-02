import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers.dart';

class HeaderInformation extends StatelessWidget {
  const HeaderInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Text(
          context
              .read<OriginalEcgProvider>()
              .ecg
              .header
              .generalHeader
              .entries
              .map((entry) => '${entry.key}: ${entry.value}\n')
              .join(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
