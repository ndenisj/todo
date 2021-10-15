import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/screens/my_todo/myTodo.model.dart';
import 'package:todo_list/utils/constants.dart';
import 'package:todo_list/widgets/background.widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list/widgets/todo.widget.dart';
import 'package:todo_list/widgets/raisedGradientButton.widget.dart';

class MyTodoView extends StatefulWidget {
  const MyTodoView({Key? key}) : super(key: key);

  @override
  State<MyTodoView> createState() => _MyTodoViewState();
}

class _MyTodoViewState extends State<MyTodoView> {
  late final SlidableController slidableController;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  dynamic editIndex;

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  List<Todo> todos = [];

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

  _showDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: kPrimaryColor,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: titleCtrl,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: kPrimaryColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: kPrimaryColor,
                              ),
                            ),
                            labelText: 'Title',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: descriptionCtrl,
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: kPrimaryColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: kPrimaryColor,
                              ),
                            ),
                            labelText: 'Description',
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedGradientButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              if (editIndex != null) {
                                todos.removeAt(editIndex);
                                todos.insert(
                                  editIndex,
                                  Todo(
                                    name: titleCtrl.text,
                                    description: descriptionCtrl.text,
                                    id: "$editIndex",
                                  ),
                                );

                                setState(() {});
                                Navigator.of(context).pop();
                                titleCtrl.clear();
                                descriptionCtrl.clear();
                                editIndex = null;
                                _showSnackBar(
                                    context, 'Todo edited successfully!');
                              } else {
                                todos.insert(
                                  todos.length,
                                  Todo(
                                    name: titleCtrl.text,
                                    description: descriptionCtrl.text,
                                    id: "${todos.length}",
                                  ),
                                );
                                // todos.add(
                                //   Todo(
                                //     name: titleCtrl.text,
                                //     description: descriptionCtrl.text,
                                //     id: "${int.parse(todos.last.id) + 1}",
                                //   ),
                                // );
                                setState(() {});
                                Navigator.of(context).pop();
                                titleCtrl.clear();
                                descriptionCtrl.clear();
                                editIndex = null;
                                _showSnackBar(
                                    context, 'Todo added successfully!');
                              }
                            }
                          },
                          width: 120.w,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.5, 0.7, 0.9],
                            colors: [
                              kSecondaryColor,
                              kSecondaryColor.withOpacity(0.9),
                              kSecondaryColor.withOpacity(0.8),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: Container(
                                  height: 20.w,
                                  width: 20.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.add,
                                    size: 13.sp,
                                    color: kSecondaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Column(
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
              child: Padding(
                padding: EdgeInsets.only(bottom: 65.h),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return _getSlidableWithLists(context, index);
                  },
                  itemCount: todos.length,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: _showDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getSlidableWithLists(BuildContext context, int index) {
    final Todo item = todos[index];
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
                    ? 'Deleted'
                    : 'Dimiss Delete');
            setState(() {
              todos.removeAt(index);
            });
          },
        ),
        actionPane: const SlidableStrechActionPane(),
        actionExtentRatio: 0.25,
        child: TodoWidget(todos[index]),
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
              onTap: () {
                titleCtrl.text = todos[index].name;
                descriptionCtrl.text = todos[index].description;
                editIndex = index;
                _showDialog();
              },
            ),
          ),
        ],
      ),
    );
  }
}
