import 'package:flutter/material.dart';
import 'package:taskmanagementapp/resources/colors.dart';

// ignore: must_be_immutable
class FilterDropDown extends StatelessWidget {
  String? selectedValue;
  final String hint;
  final Function(String?) onChanged;
  final List<String> items;

  FilterDropDown({
    super.key,
    required this.selectedValue,
    required this.hint,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white),
      ),
      padding: const EdgeInsets.only(
        left: 5,
      ),
      child: DropdownButton<String>(
        underline: Container(),
        hint: Text(hint),
        value: selectedValue,
        items: [
          DropdownMenuItem(
            value: null,
            child: Text(
              hint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          for (String item in items)
            DropdownMenuItem(
              value: item,
              child: Text(
                item,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
        borderRadius: BorderRadius.circular(5),
        onChanged: onChanged,
      ),
    );
  }
}
