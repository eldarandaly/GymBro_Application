import 'package:flutter/material.dart';
import 'dart:ui';

// class ReorderPage extends StatefulWidget {
//   final List<String> exercises;

//   ReorderPage({required this.exercises});

//   @override
//   _ReorderPageState createState() => _ReorderPageState();
// }

// class _ReorderPageState extends State<ReorderPage> {
//   late List<String> _exercises;

//   @override
//   void initState() {
//     super.initState();
//     _exercises = List.from(widget.exercises);
//   }

//   void _reorderExercises(int oldIndex, int newIndex) {
//     setState(() {
//       if (newIndex > oldIndex) {
//         newIndex -= 1;
//       }
//       final exercise = _exercises.removeAt(oldIndex);
//       _exercises.insert(newIndex, exercise);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reorder Exercises'),
//       ),
//       body: oldOne(context),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pop(context, _exercises);
//         },
//         child: Icon(Icons.check),
//       ),
//     );
//   }

//   Container oldOne(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       child: ReorderableListView.builder(
//         itemCount: _exercises.length,
//         itemBuilder: (context, index) {
//           final exercise = _exercises[index];
//           return LongPressDraggable(
//             key: Key(exercise),
//             child: ListTile(
//               title: Text(exercise),
//             ),
//             feedback: Material(
//               child: ListTile(
//                 title: Text(exercise),
//                 tileColor: Colors.red[300],
//               ),
//             ),
//             onDragStarted: () {
//               setState(() {
//                 _exercises.removeAt(index);
//               });
//             },
//             onDraggableCanceled: (_, __) {
//               setState(() {
//                 _exercises.insert(index, exercise);
//               });
//             },
//             onDragCompleted: () {
//               setState(() {
//                 _exercises.insert(index, exercise);
//               });
//             },
//           );
//         },
//         onReorder: _reorderExercises,
//       ),
//     );
//   }
// }

class ReorderPage extends StatefulWidget {
  final List<String> exercises;

  ReorderPage({required this.exercises});

  @override
  State<ReorderPage> createState() => _ReorderPageState();
}

class _ReorderPageState extends State<ReorderPage> {
  late List<String> _exercises;
  // late List<String> _items = _exercises;
  @override
  void initState() {
    super.initState();
    _exercises = List.from(widget.exercises);
  }

  void _reorderExercises(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final exercise = _exercises.removeAt(oldIndex);
      _exercises.insert(newIndex, exercise);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    final Color draggableItemColor = colorScheme.primary;

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(0, 6, animValue)!;
          return Material(
            elevation: elevation,
            color: draggableItemColor,
            shadowColor: draggableItemColor,
            child: child,
          );
        },
        child: child,
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reorder'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ReorderableListView(
          // padding: const EdgeInsets.symmetric(horizontal: 40),
          proxyDecorator: proxyDecorator,
          children: <Widget>[
            for (int index = 0; index < _exercises.length; index += 1)
              ListTile(
                key: Key('$index'),
                tileColor: index.isOdd ? oddItemColor : evenItemColor,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${_exercises[index]}'),
                ),
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                  backgroundColor: index.isOdd ? evenItemColor : oddItemColor,
                ),
              ),
          ],
          onReorder: _reorderExercises),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _exercises);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
