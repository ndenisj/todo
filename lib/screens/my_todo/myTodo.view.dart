import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/screens/my_todo/myTodo.model.dart';
import 'package:todo_list/widgets/background.widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list/widgets/permit.widget.dart';

class MyTodoView extends StatefulWidget {
  const MyTodoView({Key? key}) : super(key: key);

  @override
  State<MyTodoView> createState() => _MyTodoViewState();
}

class _MyTodoViewState extends State<MyTodoView> {
  late final SlidableController slidableController;

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  List<Todo> todos = [
    Todo(name: 'Hello 1', description: 'deloo', id: '1'),
    Todo(description: 'Desc', name: 'names', id: '2')
  ];

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    super.initState();
  }

  Animation<double>? _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double>? slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool? isOpen) {
    setState(() {
      _fabColor = isOpen! ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: Center(
                child: Text(
                  'My Todos!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32.sp,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return _getSlidableWithLists(context, index);
              },
              itemCount: todos.length,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: _addTodo,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getSlidableWithLists(BuildContext context, int index) {
    final Todo item = todos[index];
    //final int t = index;
    return Container(
      child: Slidable(
        key: Key(item.id),
        controller: slidableController,
        direction: Axis.horizontal,
        dismissal: SlidableDismissal(
          child: SlidableDrawerDismissal(),
          onDismissed: (actionType) {
            _showSnackBar(
                context,
                actionType == SlideActionType.primary
                    ? 'Dismiss Archive'
                    : 'Dimiss Delete');
            setState(() {
              todos.removeAt(index);
            });
          },
        ),
        actionPane: const SlidableStrechActionPane(),
        actionExtentRatio: 0.25,
        child: PermitWidget(todos[index]),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                todos.removeAt(index);
                Slidable.of(context)?.close();
                _showSnackBar(context, 'Delete');
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: IconSlideAction(
              caption: 'Edit',
              color: Colors.indigo,
              icon: Icons.edit,
              onTap: () => _showSnackBar(context, 'Edit'),
            ),
          ),
        ],
      ),
    );
  }

  void _addTodo() {
    todos.add(
      Todo(
        name: 'New 71',
        description: ' New description',
        id: "${todos.length + 1}",
      ),
    );
    setState(() {});
    _showSnackBar(context, 'Added!');
  }
}
