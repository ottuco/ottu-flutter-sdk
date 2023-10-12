import 'package:flutter/material.dart';
import 'package:ottu/consts/colors.dart';

class CustomRadio extends StatefulWidget {
  bool selected;
  final void Function(bool) onChanged;
  CustomRadio({
    Key? key,
    required this.onChanged,
    required this.selected,
  }) : super(key: key);

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    // bool selected = (widget.value == widget.groupValue);

    return ClipRRect(
      child: InkWell(
        onTap: () => widget.onChanged(widget.selected = !widget.selected),
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border:
                Border.all(color: widget.selected ? whiteColor : blackColor),
            color: widget.selected ? primaryColor : Colors.white,
          ),
          child: const Icon(
            Icons.check,
            size: 13,
            color: whiteColor,
          ),
        ),
      ),
    );
  }
}
