import 'package:flutter/material.dart';

import 'CommandBlock.dart';

class CommandBlockLanding extends StatefulWidget {
  const CommandBlockLanding({Key? key}) : super(key: key);

  @override
  State<CommandBlockLanding> createState() => _CommandBlockLandingState();
}

class _CommandBlockLandingState extends State<CommandBlockLanding> {
  Offset offset = const Offset(0, 0);
  @override
  Widget build(BuildContext context) {
    return DragTarget<CommandBlock>(
      onWillAccept: (value) => true,
      onAccept: (CommandBlock value) {
        // setState(() {
        //   draggedCommand = value;
        // });
      },
      onMove: (DragTargetDetails details) {
        print("onMove");

      },
      builder: (context, candidates, rejects) {
        return Container(
          color: candidates.isNotEmpty ? Colors.yellow : Colors.grey,
          height: 60.0,
          width: 60.0,
          child: Text("x: ${offset.dx}, y: ${offset.dy}"),
        );
      },
    );
  }
}
