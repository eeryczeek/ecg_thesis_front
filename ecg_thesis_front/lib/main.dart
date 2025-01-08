import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pacemaker_impact/pacemaker_impact_tab.dart';
import 'providers.dart';
import 'visualizations/visualizations_tab.dart';
import 'analysis/analysis_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AnalysisEcgProvider()),
        ChangeNotifierProvider(create: (context) => EcgBeforeProvider()),
        ChangeNotifierProvider(create: (context) => EcgAfterProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ECG Analysis',
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const MyHomePage(title: 'ECG Analysis'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Analysis'),
            Tab(text: 'Pacemaker Impact'),
            Tab(text: 'Visualizations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const AnalysisTab(),
          const PacemakerImpactTab(),
          const VisualizationsTab(),
        ],
      ),
    );
  }
}
