
import 'package:flutter/material.dart';

class AddExpenseButton extends StatelessWidget{
  const AddExpenseButton({super.key,required this.newRecord});
  final void Function() newRecord;
  @override
  Widget build(context){
    return FloatingActionButton(
          backgroundColor: Colors.tealAccent,
          onPressed: newRecord,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        );
        
  }
}