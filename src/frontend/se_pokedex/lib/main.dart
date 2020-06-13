import 'package:flutter/material.dart';
import 'package:sepokedex/controller.dart';
import 'package:sepokedex/detail_page.dart';
import 'package:sepokedex/example.dart';

import 'model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Controller _controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SE-PokeDex"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _controller.getList(),
          builder: (context, snapshot) {
            if(snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading'),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      snapshot.data[index].image,
                    ),
                  ),
                  title: Text(snapshot.data[index].name.toString()),
                  subtitle: Text(snapshot.data[index].type.join(' | ').toString().capitalizeAll()),
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))),
                );
              },
            );
          },
          ),
      ),
    );
  }
}