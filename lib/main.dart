import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController _scrollController;
  final int _perPage = 5;
  int _counter = 0;
  bool _isLoading = false; // Track loading state
  List<int> _dataCache = []; // Cache for loaded data
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      const refreshTime = Duration(seconds: 1);
      _timer = Timer.periodic(refreshTime, (timer) {
        loadData();
      });
    });

    loadData();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    if (_isLoading) return; // Prevent multiple simultaneous data loads
    _isLoading = true;
    // Simulating loading data asynchronously
    final newData =
        List.generate(_perPage, (index) => _counter * _perPage + index + 1);
    _dataCache.addAll(newData); // Add new data to cache
    _counter++; // Increment counter for pagination
    _isLoading = false;
    setState(() {}); // Update the UI after loading
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Reached the end, load more data
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Scroll Example'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _dataCache.length + 1, // +1 for loading indicator
        itemBuilder: (context, index) {
          if (index < _dataCache.length) {
            return ListTile(
              title: Text('Item ${_dataCache[index]}'),
            );
          } else {
            return _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(); // Placeholder for the loading indicator
          }
        },
      ),
    );
  }
}
