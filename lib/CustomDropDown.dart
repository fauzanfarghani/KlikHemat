import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klik_hemat/font_color_util.dart';


class CustomDropdown extends StatefulWidget {
  const CustomDropdown({super.key, required this.genders, required this.onSelected, required this.value, required this.hint, this.prefixIcon});

  final List<String> genders;
  final Function(String) onSelected;
  final String value;
  final String hint;
  final IconData? prefixIcon;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {

  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpand = !isExpand;
            });
          },
          child: Container(
            width: double.infinity,
            padding:  const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.grey.shade300
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (widget.prefixIcon != null) ...[
                      Icon(widget.prefixIcon, color: Colors.grey.shade400, size: 20,),
                      const SizedBox(width: 12,),
                    ],
                    Text(
                      widget.value.isEmpty ? widget.hint : widget.value,
                      style: TextStyle(
                          fontFamily: FontColorUtil.fontPoppins,
                          color: widget.value.isEmpty ? Colors.grey : Colors.black,fontSize: 14),
                    ),
                  ],
                ),
                Icon(isExpand ? Icons.expand_less : Icons.expand_more, color: Colors.grey,)
              ],
            ),
          ),
        ),
        isExpand ?
        Container(
            width: double.infinity,
            padding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin:  const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4)
                  )
                ],
                border: Border.all(
                    color: Colors.grey.shade200
                )
            ),
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: widget.genders.map((e)  {
                  return GestureDetector(
                    onTap: () {
                      widget.onSelected(e);
                      setState(() {
                        isExpand = false;
                      });
                    },
                    child: Padding(
                      padding:  const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        e,
                        style: TextStyle(
                            fontFamily: FontColorUtil.fontPoppins,
                            color: Colors.black,fontSize: 14),
                      ),
                    ),
                  );
                }).toList()
            )
        ) : const SizedBox.shrink(),
      ],
    );
  }
}
