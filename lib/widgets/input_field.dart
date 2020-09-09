import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final Function validator;
  final String label;
  final String placeHolder;
  final bool obscureText;
  final TextInputType textInputType;
  final Function onSaved;
  final bool isDone;
  final Function actionFunction;
  final int maxLine;
  final Icon suffixIcon;

  const InputField({Key key,
    @required this.validator,
    @required this.label,
    this.placeHolder,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
    this.onSaved,
    this.isDone = false,
    this.maxLine = 1,
    this.suffixIcon,
    this.actionFunction})
      : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      validator: widget.validator,
      onSaved: widget.onSaved,
      cursorColor: Theme
          .of(context)
          .primaryColor,
      keyboardType: widget.textInputType,
      textInputAction: widget.isDone ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).nextFocus();
        if (widget.isDone) {
          widget.actionFunction();
        }
      },
      decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.placeHolder == null ? '' : widget.placeHolder,
          suffixIcon: IconButton(
            icon: widget.suffixIcon,
            onPressed: () {
              print("here");
              widget.actionFunction();
            },
          )
      ),
      maxLines: widget.maxLine,
    );
  }
}
