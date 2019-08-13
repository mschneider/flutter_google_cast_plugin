import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_cast_plugin/flutter_google_cast_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CastStateBloc castStateBloc;

  @override
  void initState() {
    super.initState();
    castStateBloc = CastStateBloc();
  }

  @override
  void dispose() {
    castStateBloc.dispose();
    castStateBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: <Widget>[
          BlocBuilder(
            bloc: castStateBloc,
            builder: (context, state) {
              return Text('CastState: $state');
            }
          ),
          FlatButton(
              child: Text('showMediaRouteChooserDialog'),
              onPressed: SessionManager.showMediaRouteChooserDialog),
          FlatButton(
            child: Text('endCurrentSession'),
            onPressed: () {
              SessionManager.endCurrentSession(true);
            },
          )
        ]),
      ),
    );
  }
}
