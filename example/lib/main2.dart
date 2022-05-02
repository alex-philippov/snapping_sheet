import 'package:flutter/material.dart';

void main() {
  runApp(SnappingSheetExampleApp());
}

class SnappingSheetExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snapping Sheet Examples',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[700],
          elevation: 0,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        primarySwatch: Colors.grey,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DraggableScrollableController controller =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TwoSheets(
        bottomPositions: [
          .1,
          .2,
          .6,
          1,
        ],
        topPositions: [
          .2,
          1,
        ],
      ),
    );
  }
}

class TwoSheets extends StatefulWidget {
  final DraggableScrollableController? topController;
  final DraggableScrollableController? bottomController;
  final List<double> bottomPositions;
  final List<double> topPositions;
  final double betweenPadding;

  const TwoSheets({
    Key? key,
    this.topController,
    this.bottomController,
    required this.bottomPositions,
    required this.topPositions,
    this.betweenPadding = 20,
  }) : super(key: key);

  @override
  _TwoSheetsState createState() => _TwoSheetsState();
}

class _TwoSheetsState extends State<TwoSheets> {
  late final DraggableScrollableController topController =
      widget.topController ?? DraggableScrollableController();

  late final DraggableScrollableController bottomController =
      widget.bottomController ?? DraggableScrollableController();

  static SheetType? currDrag;
  late double bottomLastSnap;
  late double topLastSnap = widget.topPositions.last;

  @override
  void initState() {
    super.initState();
    bottomLastSnap = widget.bottomPositions.first;
    topController.addListener(() {
      if (currDrag == SheetType.top) {
        final screenHeight = topController.sizeToPixels(1);
        final freeSpace =
            screenHeight - topController.pixels - bottomController.pixels;

        if (freeSpace < 0 || freeSpace > 0 && bottomController.size < bottomLastSnap) {
          bottomController.jumpTo(bottomController
              .pixelsToSize(bottomController.pixels + freeSpace));
        } else if (bottomController.size > bottomLastSnap) {
          bottomController.jumpTo(bottomLastSnap);
        }
        // if (widget.topPositions.contains(topController.size)) {
        //   // setState(() {
        //   //   currDrag = null;
        //   // });
        // }
      }
    });
    bottomController.addListener(() {
      if (currDrag == SheetType.top) return;
      if (currDrag == null &&
          widget.bottomPositions.contains(bottomController.size)) {
        setState(() {
          bottomLastSnap = bottomController.size;
          print("last bot: $bottomLastSnap");
        });
      }
      // bottomLastSnap = bottomController.size;
    });
  }

  @override
  void dispose() {
    topController.dispose();
    bottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.yellow,
            child: Listener(
              onPointerDown: (event) {
                // setState(() {
                currDrag = SheetType.top;
                bottomLastSnap = bottomController.size;
                // });
              },
              onPointerUp: (event) {
                // setState(() {
                currDrag = null;
                // });
              },
              child: NotificationListener(

                child: DraggableScrollableSheet(
                  expand: false,
                  snap: true,
                  minChildSize: 0,
                  maxChildSize: widget.topPositions.last,
                  initialChildSize: widget.topPositions.first,
                  snapSizes: widget.topPositions,
                  controller: topController,
                  builder: (context, scrollController) {
                    return Container(
                      color: Colors.red,
                      child: ListView.builder(
                        reverse: true,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(index.toString()),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.yellow,
            child: Listener(
              onPointerDown: (event) {
                currDrag = SheetType.bottom;
              },
              onPointerUp: (event) {
                currDrag = null;
              },
              child: DraggableScrollableSheet(
                snap: true,
                expand: false,
                minChildSize: 0,
                maxChildSize: widget.bottomPositions.last,
                initialChildSize: widget.bottomPositions.first,
                snapSizes: widget.bottomPositions,
                controller: bottomController,
                builder: (context, scrollController) {
                  return Container(
                    color: Colors.green,
                    child: ListView.builder(
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(index.toString()),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum SheetType {
  top,
  bottom,
}
