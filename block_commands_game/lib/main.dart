import 'package:block_commands_game/CommandBlock.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Command.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellowAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.lightBlueAccent,
              child: Theme(
                data: ThemeData.light(),
                child: Center(
                  child: SizedBox(
                    width: 800,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "King Karel",
                            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                child: const Text("Stories"),
                                onPressed: () {},
                              ),
                              RawMaterialButton(
                                mouseCursor: SystemMouseCursors.forbidden,
                                padding: EdgeInsets.zero,
                                child: const Text("Crowns"),
                                onPressed: () {},
                              ),
                              MaterialButton(
                                child: const Text("Profile"),
                                onPressed: () {},
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Expanded(
              flex: 1,
              child: GameContainer(),
            ),
          ],
        ),
      ),
    );
  }
}

class GameContainer extends StatefulWidget {
  const GameContainer({Key? key}) : super(key: key);

  @override
  _GameContainerState createState() => _GameContainerState();
}

class _GameContainerState extends State<GameContainer> {
  List<Command> commands = [];
  Offset offset = const Offset(0, 0);

  final _commandListGlobalKey = GlobalKey(debugLabel: "command list");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.redAccent,
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: 230,
              child: Container(
                color: Colors.lightGreenAccent,
                child: ListView(
                  key: _commandListGlobalKey,
                  shrinkWrap: true,
                  children: [
                    for (int i = 0; i < commands.length; i++)
                      CommandBlockGraggableWrapper(
                        key: ValueKey<Command>(commands[i]),
                        child: CommandBlock(command: commands[i]),
                        blockErased: () {
                          setState(() {
                            commands.removeAt(i);
                          });
                        },
                      ),
                    // ListView.builder(
                    //   key: commandListGlobalKey,
                    //   shrinkWrap: true,
                    //   // onReorder: (int oldIndex, int newIndex) {
                    //   //   if (newIndex > oldIndex) {
                    //   //     newIndex -= 1;
                    //   //   }
                    //   //   final item = commands.removeAt(oldIndex);
                    //   //   setState(() {
                    //   //     commands.insert(newIndex, item);
                    //   //   });
                    //   // },
                    //   itemCount: commands.length * 2,
                    //   itemBuilder: (context, index) {
                    //     if (index % 2 == 0) {
                    //       // return (Text("${(index/2).floor()} / ${commands.length}"));
                    //       return CommandBlockGraggableWrapper(
                    //         key: ValueKey<Command>(commands[(index / 2).floor()]),
                    //         child: CommandBlock(command: commands[(index / 2).floor()]),
                    //         blockErased: () {
                    //           setState(() {
                    //             commands.removeAt((index / 2).floor());
                    //           });
                    //         },
                    //       );
                    //     }
                    //     return const Text("target");
                    //   },
                    // ),
                    DragTarget<CommandBlock>(
                      onWillAccept: (value) => true,
                      onAccept: (CommandBlock value) {
                        setState(() {
                          commands.add(Command.clone(value.command));
                        });
                      },
                      onMove: (DragTargetDetails details) {
                        setState(() {
                          offset = details.offset;
                        });
                      },
                      builder: (context, candidates, rejects) {
                        return Container(
                          margin: const EdgeInsets.all(8),
                          height: 60.0,
                          width: 60.0,
                          color: candidates.isNotEmpty ? Colors.yellow : Colors.grey,
                          child: Text("x: ${offset.dx}, y: ${offset.dy}"),
                        );
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          RenderBox render = _commandListGlobalKey.currentContext?.findRenderObject() as RenderBox;
                          render.visitChildren((RenderObject child) {
                            print(child.runtimeType);
                            RenderBox childRender = child as RenderBox;
                            Offset position = childRender.globalToLocal(Offset.zero);
                            print("x1 ${position.dy}");
                          });
                          // Offset position = render.globalToLocal(Offset.zero);
                          // double topY = position.dy;
                          // double bottomY = topY + render.size.height;
                          //
                          // print((_commandListGlobalKey.currentContext));
                          // for (int i = 0; i < commands.length; i++) {
                          //   //ValueKey key = ValueKey<Command>(commands[i]);
                          //   print(commands[i].name);
                          // }
                        },
                        child: const Text("compute")),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            left: 240,
            child: Container(
              color: Colors.blueGrey,
              child: const Text("beta"),
            ),
          ),
          Positioned(
            left: 230,
            child: SizedBox(
              width: 100,
              child: Container(
                color: Colors.green,
                child: Column(
                  children: [
                    Text("commands"),
                    CommandBlockGraggableWrapper(
                      child: CommandBlock(
                        command: Command("alpha"),
                      ),
                    ),
                    CommandBlockGraggableWrapper(
                      child: CommandBlock(
                        command: Command("beta"),
                      ),
                    ),
                    CommandBlockGraggableWrapper(
                      child: CommandBlock(
                        command: Command("gamma"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CommandBlockGraggableWrapper extends StatefulWidget {
  final CommandBlock child;
  final Function? blockErased;

  const CommandBlockGraggableWrapper({Key? key, required this.child, this.blockErased}) : super(key: key);

  @override
  State<CommandBlockGraggableWrapper> createState() => _CommandBlockGraggableWrapperState();
}

class _CommandBlockGraggableWrapperState extends State<CommandBlockGraggableWrapper> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: MouseRegion(
        cursor: SystemMouseCursors.grabbing,
        child: Draggable<CommandBlock>(
          onDragUpdate: (DragUpdateDetails details) {
            // TODO
          },
          feedback: Material(
            color: Colors.transparent,
            child: widget.child,
          ),
          data: widget.child,
          child: widget.child,
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            if (widget.blockErased != null && offset.distance > 200) {
              widget.blockErased!();
            }
          },
        ),
      ),
    );
  }
}

class ScrollableDraggable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScrollingDragger();
}

class _ScrollingDragger extends State<ScrollableDraggable> {
  final _listViewKey = GlobalKey();
  final ScrollController _scroller = ScrollController();
  bool _isDragging = false;

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _createContents();
  }

  Widget _createContents() {
    final itemCount = 20;
    final listView = ListView.builder(
      shrinkWrap: true,
      key: _listViewKey,
      physics: ClampingScrollPhysics(),
      controller: _scroller,
      itemCount: itemCount + 1,
      itemBuilder: (context, index) {
        final data = ListTile(title: Text("data-$index"));

        final draggable = Draggable(
          child: _decorate(data),
          feedback: Material(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              child: _decorate(data, color: Colors.red),
            ),
          ),
          onDragStarted: () => _isDragging = true,
          onDragEnd: (details) => _isDragging = false,
          onDraggableCanceled: (velocity, offset) => _isDragging = false,
        );

        if (index != itemCount) {
          return draggable;
        }
        return const SizedBox(height: 250);
      },
    );

    return _createListener(listView);
  }

  Widget _createListener(Widget child) {
    return Listener(
      child: child,
      onPointerMove: (PointerMoveEvent event) {
        print("x: ${event.position.dx}, ${event.position.dy}");

        if (!_isDragging) {
          return;
        }
        RenderBox render = _listViewKey.currentContext?.findRenderObject() as RenderBox;
        Offset position = render.globalToLocal(Offset.zero);
        double topY = position.dy;
        double bottomY = topY + render.size.height;

        print("x: ${position.dy}, "
            "y: ${position.dy}, "
            "height: ${render.size.width}, "
            "width: ${render.size.height}");

        const detectedRange = 100;
        const moveDistance = 3;

        if (event.position.dy < topY + detectedRange) {
          var to = _scroller.offset - moveDistance;
          to = (to < 0) ? 0 : to;
          _scroller.jumpTo(to);
        }
        if (event.position.dy > bottomY - detectedRange) {
          _scroller.jumpTo(_scroller.offset + moveDistance);
        }
      },
    );
  }

  Widget _decorate(Widget child, {Color color = Colors.black}) {
    return Container(
      child: child,
      decoration: BoxDecoration(border: Border.all(color: color, width: 1)),
    );
  }
}

/*
https://github.com/flutter/flutter/issues/52630

      RenderBox child = childKey.currentContext.findRenderObject();
      Offset childOffset = child.localToGlobal(Offset.zero);
      //convert
      RenderBox parent =
          parentKey.currentContext.findRenderObject();
      Offset childRelativeToParent = parent.globalToLocal(childOffset);
 */
