import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/task/task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'ToDoList',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  //todo list of tasks
  var taskList = <Task>[];
}


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch(selectedIndex) {
      case 0:
        page = TaskCreator();
        break;
      case 1:
        page = TasksPage();
        break;
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }
    return LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.task),
                        label: Text('Tasks'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                      print('selected: $value');
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}


class TaskCreator extends StatefulWidget {
  @override
  State<TaskCreator> createState() => _TaskCreatorState();
}

class _TaskCreatorState extends State<TaskCreator> {
  final nazovController = TextEditingController();
  final popisController = TextEditingController();

  @override
  void dispose(){
    nazovController.dispose();
    popisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        children: [
          TextFormField(
            controller: nazovController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Nazov ulohy',
            ),
          ),
          TextFormField(
            controller: popisController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Strucny popis',
            ),
          ),
          ElevatedButton(onPressed: (){
            if(nazovController.text.isEmpty || popisController.text.isEmpty) {
              print('Prazdne hodnoty');
              return;
            }
            Task task = Task(nazovController.text, popisController.text);
            for(Task taskIn in appState.taskList) {
              if(taskIn.name == task.name) {
                    print('Task s danym nazvom uz existuje');
                    return;
                  }
                }
              print('Podarilo sa');
              appState.taskList.add(task);

              }, child: Text('Pridaj ulohu'))
        ],
      ),
    );
  }
}

class TasksPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if(appState.taskList.isEmpty) {
      return Center(
        child: Text('You have no tasks yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20) ,
          child: Text('You have ${appState.taskList.length} tasks:'),
        ),
      for (var task in appState.taskList)
        ListTile(
          leading: FlutterLogo(size: 72.0,),
          title: Text(task.name),
          subtitle: Text(task.description),
          trailing: ElevatedButton(onPressed: () {
            appState.taskList.remove(task);
    },
          child: null,)
          ),
      ],
    );
  }
}

