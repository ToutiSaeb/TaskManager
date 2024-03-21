import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskForm(),
    );
  }
}

class TaskForm extends StatefulWidget {
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<dynamic> tache=[];
refresh(){
setState(() {
    Navigator.of(context).pushReplacement(
  MaterialPageRoute(
    builder: (context) => TaskForm(), 
  ),
);
});

}
  Future<void> _createTask() async {
    final String url = 'http://10.0.2.2:8000/api/addtasks/'; // Adjust URL as needed
    final Map<String, String> data = {
      'title': _titleController.text,
      'description': _descriptionController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Task created successfully
        print('Task created: ${response.body}');
      } else {
        // Failed to create task
        print('Failed to create task: ${response.statusCode}');
      }
    } catch (error) {
      // Error occurred during POST request
      print('Error creating task: $error');
    }
  }
  Future<void> _afficheTask() async {
  final String url = 'http://10.0.2.2:8000/api/affichtasks/';
  try {
    final response = await http.get(
      Uri.parse(url),
    );
    
    if (response.statusCode == 200) {
      // Vérifiez si la réponse est réussie (statut 200)
      // Convertissez le corps de la réponse JSON en une liste de tâches
      tache = jsonDecode(response.body);
      
      // Ajoutez chaque tâche à la liste `tache`
      print(tache);
      
    } else {
      // Affichez le statut de la réponse si la requête a échoué
      print('Failed to retrieve tasks: ${response.statusCode}');
    }
  } catch (error) {
    // Affichez les erreurs rencontrées lors de la requête
    print('Error retrieving tasks: $error');
  }
  setState(() {
    
  });
}
  Future<void> _deleteTask(int taskId) async {
    final String url = 'http://10.0.2.2:8000/api/deletetasks/$taskId/';
    try {
      final response = await http.delete(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        print('Task deleted');
      } else {
        _afficheTask();
        print('Task not found');
      }
    } catch (error) {
      print('Error deleting task: $error');
    }
    setState(() {});
  }
   
  Future<void> _updateTask(int taskIdupdate) async {
    final String url = 'http://10.0.2.2:8000/api/updatetasks/$taskIdupdate/';
    final Map<String, String> data = {
      'title': _titleController.text,
      'description': _descriptionController.text,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Task updated: ${response.body}');
        _afficheTask(); 
      } else {
        print('Failed to update task: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating task: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
       
          children: [
            Row(
              children: [
                Expanded(
                        child:  ElevatedButton(
                        onPressed: _afficheTask,
                        child: Text('affich Task'),
                      ),
                     ),
                     Expanded(
                        child:  ElevatedButton(
                        onPressed: _createTask,
                        child: Text('add Task'),
                      ),
                     ),
                     Expanded(
                        child:  ElevatedButton(
                        onPressed: refresh,
                        child: Text('Refresh'),
                      ),
                     ),
              ],

            ),
           
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 32),
             ...List.generate(tache.length, (index) => InkWell(
              onLongPress: () {
               showDialog(
                  context: context,
                   builder: (BuildContext context) {
                      return AlertDialog(
                                  title: Text('Alert Title'),
                                  content: Text('Alert Message'),
                                  actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      _deleteTask(int.parse('${tache[index]['id']}'));
                                      Navigator.pop(context);
                                      },
                                      child: Text('delete'),
                                      ),
                                       TextButton(
                                    onPressed: () {
                                      _updateTask(tache[index]['id']);
                                      Navigator.pop(context);
                                      },
                                      child: Text('update'),
                                      ),
                                      ],
                                  );
                                      },
                                    );

                 

              },
               child: Card(
                
                color: const Color.fromARGB(255, 231, 204, 202),
                child: ListTile(
                title: Text("${tache[index]['title']}",),
                subtitle:Text("${tache[index]['description']}",) ,
                ),
                
                           ),
             )),
            
           


          ],
        ),
      ),
    );
  }
}
