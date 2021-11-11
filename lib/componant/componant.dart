import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:todo_app/cubit/cubit.dart';

import '../modules/todoapp/title.dart';


Widget defaultTextField({
  required TextEditingController? controller,
  required TextInputType? type,
  Function()? onTap,
  int lines = 1,
  Function(String)? onChange,
  required String? Function(String?)? onValidate,
  String Function(String?)? onSubmit,
  bool isPassword = false,
  required String? label,
  required IconData? prefix,
  IconData? suffix,
  Function()? suffixPress,
}) {
  return TextFormField(
    controller: controller,
    maxLines: lines,
    keyboardType: type,
    obscureText: isPassword,
    onChanged: onChange,
    onTap: onTap,
    onFieldSubmitted: onSubmit,
    validator: (value) {
      return onValidate!(value);
    },
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: suffix != null
          ? IconButton(onPressed: suffixPress, icon: Icon(suffix))
          : null,
      border: OutlineInputBorder(),
    ),
  );
}

Widget buildTaskItem(Map model, context) {
  var scaffoldMasenger =ScaffoldMessenger.of(context) ;
  return Slidable(

    actionPane: SlidableDrawerActionPane(),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            child: Text('${model['time']}'),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Titless(model['texxt'], model['tiastle']),
                    ),
                  );
                },
                icon: Icon(
                  Icons.description,
                  color: Colors.grey,
                )),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      IconSlideAction(
        color: Colors.green,
        icon: Icons.check_box,
        onTap: () {
          scaffoldMasenger.showSnackBar(snackBar(text: 'changed to done item', color:Colors.green));

          AppCubit.get(context).updateDatabase(status: 'done', id: model['id']);
        },
      ),
      IconSlideAction(
        color: Colors.blueGrey,
        icon: Icons.archive,
        onTap: () {
          scaffoldMasenger.showSnackBar(snackBar(text: 'changed to archived item', color:Colors.grey));

          
          AppCubit.get(context)
              .updateDatabase(status: 'archived', id: model['id']);
        },
      ),
    ],
    secondaryActions: [
      IconSlideAction(
        color: Colors.red,
        icon: Icons.close,
        onTap: () {
          scaffoldMasenger.showSnackBar(snackBar(text: 'delete', color: Colors.red));
          AppCubit.get(context).deleteRows(model['id']);
        },
      ),
    ],
  );
}
SnackBar snackBar (
    {
      required String text,
      required Color color
    })
{
  return SnackBar(
    backgroundColor: color,
    duration: Duration(seconds:2),
    content:Text(text,
      style:TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ) ,
    ),

  );
}

