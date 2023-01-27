import 'package:flutter/material.dart';

enum OVERLAY_POSITION { TOP, BOTTOM }

class OverlayChildParent extends StatefulWidget {
  final Widget? child;
  final Widget? overlied;
  final int? numOfItems;

  OverlayChildParent(this.child, this.overlied, this.numOfItems);
  @override
  _OverlayChildParentState createState() => _OverlayChildParentState();
}

class _OverlayChildParentState extends State<OverlayChildParent> {
  TapDownDetails? _tapDownDetails;
  OverlayEntry? _overlayEntry;
  OVERLAY_POSITION? _overlayPosition;

  double? _statusBarHeight;
  final key = GlobalKey();
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = key.currentContext!.findRenderObject()! as RenderBox;

    var size = renderBox.size;

    var offset = renderBox.localToGlobal(Offset.zero);
    var globalOffset = Offset(
        _tapDownDetails!.globalPosition.dx, _tapDownDetails!.globalPosition.dy);

    _statusBarHeight = MediaQuery.of(context).padding.top;

    var screenHeight = MediaQuery.of(context).size.height;

    var remainingScreenHeight = screenHeight - _statusBarHeight!;

    if ((globalOffset.dy + (size.height * (widget.numOfItems! + 1))) >
        remainingScreenHeight) {
      _overlayPosition = OVERLAY_POSITION.TOP;
    } else {
      _overlayPosition = OVERLAY_POSITION.BOTTOM;
    }
    return OverlayEntry(builder: (context) {
      return Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _overlayEntry!.remove();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.blueGrey.withOpacity(0.1),
            ),
          ),
          Positioned(
            left: size.width,
            right: size.width,
            top: _overlayPosition == OVERLAY_POSITION.TOP
                ? null
                : offset.dy - 5.0,
            bottom: _overlayPosition == OVERLAY_POSITION.TOP
                ? _statusBarHeight!
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                body(context, offset.dy),
              ],
            ),
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
      child: widget.child,
      onTapDown: (TapDownDetails tapDown) {
        if (widget.numOfItems == 0) return;
        setState(() {
          _tapDownDetails = tapDown;
        });
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context)!.insert(this._overlayEntry!);
      },
    );
  }

  Widget body(BuildContext context, double offset) {
    return Container(
      child: widget.overlied,
      margin: EdgeInsets.only(bottom: 5),
    );
  }
}
