import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/componant/componant.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/cubit_state.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
      if (state is AppInsertDatabaseState) {
        AppCubit.get(context).titleController.clear();
        AppCubit.get(context).timeController.clear();
        AppCubit.get(context).dateController.clear();
        AppCubit.get(context).texxtController.clear();
        Navigator.pop(context);
      }
    }, builder: (context, state) {
      AppCubit cubit = AppCubit.get(context);
      return Scaffold(
        key: cubit.scaffoldkey,
        appBar: AppBar(
          title: Text(cubit.appbarTitle[cubit.currentIndex]),
        ),

        body: Conditional.single(
          context: context,
          conditionBuilder: (context) => state is! AppGetDatabaseLoadingState,
          widgetBuilder: (context) => cubit.screens[cubit.currentIndex],
          fallbackBuilder: (context) =>
              Center(child: CircularProgressIndicator()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (cubit.isBottomSheetShown) {
              if (cubit.formkey.currentState!.validate()) {
                cubit.insertToDatabase(
                  title: cubit.titleController.text,
                  time: cubit.timeController.text,
                  date: cubit.dateController.text,
                  texxt: cubit.texxtController.text,
                );
              }
            } else {
              cubit.scaffoldkey.currentState!
                  .showBottomSheet((context) {
                    return SingleChildScrollView(
                      child: Container(
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: cubit.formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextField(
                                  controller: cubit.titleController,
                                  type: TextInputType.text,
                                  onValidate: (value) {
                                    if (value!.isEmpty) {
                                      return 'title can\'t be empty';
                                    }
                                  },
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultTextField(
                                  controller: cubit.timeController,
                                  type: TextInputType.text,
                                  onValidate: (value) {
                                    if (value!.isEmpty) {
                                      return 'time can\'t be empty';
                                    }
                                  },
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      cubit.timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  label: 'Task Time',
                                  prefix: Icons.more_time,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultTextField(
                                  controller: cubit.dateController,
                                  type: TextInputType.text,
                                  onValidate: (value) {
                                    if (value!.isEmpty) {
                                      return 'date can\'t be empty';
                                    }
                                  },
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2050-12-31'),
                                    ).then((value) {
                                      cubit.dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  label: 'Task Date',
                                  prefix: Icons.calendar_today,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                SingleChildScrollView(
                                  child: defaultTextField(
                                    lines: 8,
                                    onValidate: (value) {},
                                    controller: cubit.texxtController,
                                    type: TextInputType.text,
                                    label: 'Task description',
                                    prefix: Icons.description,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
                  .closed
                  .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
              cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
            }
          },
          child: Icon(
            cubit.fabIcon,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: cubit.currentIndex,
          onTap: (index) {
            cubit.changeIndex(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: 'done tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined),
              label: 'archived',
            ),
          ],
          unselectedItemColor: Colors.grey,
        ),
      );
    });
  }
}
