import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class DragDropColors extends StatefulWidget {
  const DragDropColors({Key? key}) : super(key: key);

  static const routeName = '/drag-colors';

  @override
  State<DragDropColors> createState() => _DragDropColorsState();
}

class _DragDropColorsState extends State<DragDropColors> {
  Color myColor = Colors.brown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                MyDraggable(color: Colors.red),
                MyDraggable(color: Colors.green),
                MyDraggable(color: Colors.brown),
                MyDraggable(color: Colors.blue),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(),
            ),
            const Text('dávej sem:'),
            DragTarget<Color>(
              onWillAccept: (value) => value != Colors.black,
              onAccept: (value) {
                setState(() {
                  myColor = value;
                });
              },
              onLeave: (value) {
                print("b");
              },
              builder: (context, candidates, rejects) {
                return candidates.isNotEmpty
                    ? Container(
                        height: 100.0,
                        width: 100.0,
                        color: Colors.yellow,
                      )
                    : Container(
                        height: 100.0,
                        width: 100.0,
                        color: myColor,
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}

class MyDraggable extends StatelessWidget {
  final MaterialColor color;
  const MyDraggable({
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: color,
      feedback: Container(
        height: 42.0,
        width: 42.0,
        color: color.shade600,
      ),
      childWhenDragging: Container(
        height: 42.0,
        width: 42.0,
        color: color.shade400,
      ),
      child: Container(
        height: 42.0,
        width: 42.0,
        color: color.shade200,
      ),
    );
  }
}
