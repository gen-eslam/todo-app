import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/componant/componant.dart';

import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/cubit_state.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state)
      {
        if(AppCubit.get(context).doneTasks.isEmpty)
          {
            return Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                [
                  Icon(Icons.menu,color: Colors.grey,size: 100,),
                  Text('NO TASKS ',style: TextStyle(fontSize: 40,color: Colors.grey),)
                ],
              ),
            );
          }else
            {
              return ListView.separated(
                itemBuilder: (context, index) => buildTaskItem(AppCubit.get(context).doneTasks[index],context),
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
                itemCount:AppCubit.get(context).doneTasks.length,
              );
            }
      },
    );
  }
}
