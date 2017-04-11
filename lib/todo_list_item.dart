import 'package:flutter/material.dart';

class TodoListItem extends StatefulWidget {
  final bool isExpanded;
  final String title;
  final bool done;
  final String description;

  // Is `true` if this item is the first to be shown
  final bool isFirstItem;

  TodoListItem({this.title,
  this.description,
  this.done,
  this.isExpanded: false,
  this.isFirstItem: false,
  key})
      : super(key: key);

  @override
  _TodoListItemState createState() {
    return new _TodoListItemState(done, isExpanded);
  }
}

class _TodoListItemState extends State<TodoListItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded;
  bool _done;
  AnimationController _controller;
  Animation<double> _animation;

  _TodoListItemState(this._done, this._isExpanded);

  @override
  void initState() {
    _controller = new AnimationController(
        duration: new Duration(milliseconds: 300), vsync: this);
    _animation = new CurvedAnimation(parent: _controller, curve: Curves.ease);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  TextStyle getTitleStyle() => new TextStyle(
        color: _done ? Colors.grey[500] : Colors.black,
        fontFamily: "Rubik",
        fontSize: 18.0,
        decoration: _done ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: Colors.grey[500],
      );

  IconButton getLeadingIcon() => new IconButton(
        icon: new Icon(
          _done ? Icons.check_circle : Icons.radio_button_unchecked,
          color: Colors.amber[500],
        ),
        onPressed: toggleDone,
        padding: const EdgeInsets.all(0.0),
      );

  IconButton getExpandIcon() => new IconButton(
        icon: new Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: Colors.black,
        ),
        onPressed: toggleExpandedIcon,
        padding: EdgeInsets.zero,
      );

  void toggleDone() {
    setState(() {
      _done = !_done;
    });
  }

  void toggleExpandedIcon() {
    if (!_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    _isExpanded = !_isExpanded;
  }

  Widget buildCollapsed() {
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Row(children: [
            getLeadingIcon(),
            new Container(width: 12.0),
            new Text(widget.title, style: getTitleStyle()),
          ]),
          new RotationTransition(
              turns: new Tween(begin: 0.0, end: 0.5).animate(_animation),
              child: getExpandIcon()),
        ],
      ),
    );
  }

  Widget buildHiddenContent() {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 2.0),
          new Container(
              padding: const EdgeInsets.only(left: 52.0),
              child: new Text(
                  widget.description,
                  style: new TextStyle(fontFamily: 'Rubik'),
                  ),
          ),
          new Container(height: 16.0),
          new Container(
              padding: new EdgeInsets.only(
                  left: 52.0,
                  right: 16.0,
                  bottom: 16.0,
                  ),
              child: new Row(
                  children: [
                    new Icon(Icons.calendar_today),
                    new Container(width: 8.0),
                    new Text("Today",
                        style: new TextStyle(
                            fontFamily: 'Rubik', fontSize: 18.0)),
                  ],
                  ),
              ),
        ]);
  }

  Widget buildExpanded(BuildContext context) {
    return new Container(
        decoration: new BoxDecoration(
            backgroundColor: Colors.white,
            border: new Border(
                bottom: new BorderSide(color: Theme
                    .of(context)
                    .dividerColor),
        ),
            ),
    // padding: const EdgeInsets.all(16.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildCollapsed(),
              new SizeTransition(
                  axisAlignment: 0.0,
                  sizeFactor: _animation,
                  child: buildHiddenContent())
            ]),
        );
  }

  @override
  Widget build(BuildContext context) {
    return buildExpanded(context);
  }
}
