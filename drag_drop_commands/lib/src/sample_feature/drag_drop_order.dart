import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class DragDropOrder extends StatefulWidget {
  const DragDropOrder({Key? key}) : super(key: key);

  static const routeName = '/drag-order';

  @override
  State<DragDropOrder> createState() => _DragDropOrderState();
}

class _DragDropOrderState extends State<DragDropOrder> {
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
            const CommandRow(),
          ],
        ),
      ),
    );
  }
}

class CommandRow extends StatefulWidget {
  const CommandRow({Key? key}) : super(key: key);

  @override
  _CommandRowState createState() => _CommandRowState();
}

class _CommandRowState extends State<CommandRow> {
  final List<CommandWidget> commands = [];

  void replaceCommand(CommandWidget origin, CommandWidget replacement) {
    setState(() {
      int index = commands.indexOf(origin);
      removeCommand(origin);
      commands.insert(index, replacement);
    });
  }

  void removeCommand(CommandWidget command) {
    setState(() {
      commands.remove(command);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 100, maxWidth: 400),
          child: ReorderableListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final CommandWidget item = commands.removeAt(oldIndex);
                commands.insert(newIndex, item);
              });
            },
            children: [
              for (CommandWidget command in commands)
                DragTarget<MyDraggable>(
                  key: ValueKey(command),
                  onWillAccept: (value) => true,
                  onAccept: (value) {
                    var replacement = CommandWidget(
                      color: value.color,
                      callback: removeCommand,
                    );
                    replaceCommand(command, replacement);
                  },
                  builder: (context, candidates, rejects) {
                    return candidates.isNotEmpty
                        ? Container(
                            height: 60.0,
                            width: 60.0,
                            color: Colors.yellow,
                          )
                        : command;
                  },
                ),
            ],
          ),
        ),
        DragTarget<MyDraggable>(
          onWillAccept: (value) => true,
          onAccept: (value) {
            setState(() {
              commands.add(CommandWidget(
                color: value.color,
                callback: removeCommand,
              ));
            });
          },
          builder: (context, candidates, rejects) {
            return candidates.isNotEmpty
                ? Container(
                    height: 60.0,
                    width: 60.0,
                    color: Colors.yellow,
                  )
                : Container(
                    height: 60.0,
                    width: 60.0,
                    color: Colors.grey,
                  );
          },
        ),
      ],
    );
  }
}

class CommandWidget extends StatelessWidget {
  final Color color;
  final Function(CommandWidget) callback;
  const CommandWidget({required this.color, required this.callback, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback(this),
      child: Container(
        height: 60.0,
        width: 60.0,
        color: color,
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
    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Draggable<MyDraggable>(
        data: this,
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
      ),
    );
  }
}
