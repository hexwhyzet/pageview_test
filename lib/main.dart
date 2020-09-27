import 'package:flutter/material.dart';
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

// Storage - объект с которого происходит считывание страниц
// Когда нажимаешь кнопку я ожидаю, что произошет rebuild, чтобы pageView
// показывал нулевой индекс, но после обновления это не происходит
// Однако, если после нажания кнопки поменять вкладку, то при
// построении начальная траница будет покащываться правильно


class Storage {
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  var colors = [Colors.red, Colors.blue];
  var color = 0;
  var initialIndex = 0;

  void update() {
    color = 1 - this.color;
    initialIndex = 0;
  }

  MaterialColor getColor() {
    return this.colors[this.color];
  }
}

class MyApp extends StatelessWidget {
  var storage = Storage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(storage: storage),
    );
  }
}

class MyHomePage extends StatefulWidget {
  Storage storage;

  MyHomePage({this.storage});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void update() {
    developer.log('Old index - ' + widget.storage.initialIndex.toString());
    setState(() {widget.storage.update();});
    developer.log('New index - ' + widget.storage.initialIndex.toString());
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'LEFT',),
              Tab(text: 'RIGHT',),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeScreen(storage: widget.storage, updater: update,),
            HomeScreen(storage: widget.storage, updater: update,)
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  Storage storage;
  Function updater;

  HomeScreen({this.storage, this.updater});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          return Page(
              color: storage.getColor(),
              number: storage.numbers[position]);
        },
        controller: PageController(initialPage: storage.initialIndex),
        onPageChanged: (index) {
          storage.initialIndex = index;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updater();
          developer.log(storage.initialIndex.toString());
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Page extends StatelessWidget {
  MaterialColor color;
  int number;

  Page({this.color, this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(number.toString()),
      ),
    );
  }
}
