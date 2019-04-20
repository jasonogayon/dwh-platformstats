import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'constants/storage.dart';
import 'model/stats.dart';
import 'components/banner.dart';
import 'screens/home.dart';
import 'screens/details.dart';
import 'screens/search.dart';
import 'screens/login.dart';


void main() => runApp(PlatformStats());

class PlatformStats extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScopedModel<Stats>(
      model: Stats(),
      child: MaterialApp(
        title: 'Platform Stats',
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: <String, WidgetBuilder> {
          '/stats': (BuildContext ctx) => DefaultTabController(length: 2, child: stats()),
        },
      ),
    );
  }
}

ScopedModelDescendant<Stats> stats() {
  return ScopedModelDescendant<Stats>(
    builder: (ctx, child, model) => Statistics(storage: Storage()),
  );
}


class Statistics extends StatefulWidget {
  final Storage storage;

  Statistics({Key key, this.storage}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> with SingleTickerProviderStateMixin {
  String storageState;
  TabController _tabController;

  Future<File> writeData() async {
    setState(() {
      storageState = 'test';
    });
    return widget.storage.writeData(storageState);
  }


  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);

    writeData();
    widget.storage.readData().then((String value) {
      setState(() {
        storageState = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar:
        statsBanner(),
      bottomNavigationBar:
        Container(
          color: Colors.blue[800],
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.home, size: 28.0)),
              Tab(icon: Icon(Icons.dashboard, size: 28.0)),
              Tab(icon: Icon(Icons.search, size: 28.0)),
            ],
            labelColor: Colors.orangeAccent,
            unselectedLabelColor: Colors.grey[300],
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(8.0),
            indicatorColor: Colors.white,
          ),
        ),
      body:
        TabBarView(
          controller: _tabController,
          children: <Widget>[
            HomePage(),
            DetailsPage(),
            SearchPage(),
          ],
        )
    );
  }
}
