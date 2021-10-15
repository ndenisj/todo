import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/screens/my_todo/myTodo.model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget(this.item);
  final Todo item;

  static Color _getColors(int index) {
    switch (index % 4) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      default:
        return Colors.indigoAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    int randomIndex = random.nextInt(2);

    return GestureDetector(
      onTap: () =>
          Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
              ? Slidable.of(context)?.open()
              : Slidable.of(context)?.close(),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: const Offset(
                2.0,
                2.0,
              ),
            )
          ],
          border: Border(
            left: BorderSide(
              color: _getColors(randomIndex),
              width: 3.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.name}',
              style: TextStyle(
                fontSize: 16.sp,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              '${item.description}',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
