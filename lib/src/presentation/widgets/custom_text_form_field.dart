import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/theme/app_colors.dart';
import '../../../../utils/theme/app_text_style.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? subLabelText;
  final bool? obscureText;
  final String? prefixText;
  final Widget? prefix;
  final bool? isRequired;
  final bool? separateLabel;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final String? helperText;
  final FocusNode? focusNode;
  final bool? toggleVisibility;
  final Function()? onToggleVisibility;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final Function(String)? onChanged;
  final bool? readOnly;
  final bool? isDense;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final BoxConstraints? prefixIconConstraints;
  final Function()? onTap;
  final Function(String)? onFieldSubmitted;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.subLabelText,
    this.obscureText,
    this.prefixText,
    this.prefix,
    this.floatingLabelBehavior,
    this.isRequired,
    this.separateLabel,
    this.helperText,
    this.focusNode,
    this.toggleVisibility,
    this.onToggleVisibility,
    this.controller,
    this.prefixIcon,
    this.keyboardType,
    this.textCapitalization,
    this.onChanged,
    this.readOnly,
    this.isDense,
    this.inputFormatters,
    this.validator,
    this.prefixIconConstraints,
    this.onTap,
    this.onFieldSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      obscureText: obscureText ?? false,
      style: AppTextStyle.bodyMedium,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly ?? false,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      onChanged: (val) => onChanged != null ? onChanged!(val) : null,
      validator: (val) => validator != null ? validator!(val) : null,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        contentPadding:
        isDense ?? false
            ? EdgeInsets.symmetric(horizontal: 12, vertical: 8)
            : null,
        isDense: true,
        floatingLabelBehavior: floatingLabelBehavior,
        hintText: hintText,
        prefixText: prefixText,
        prefixStyle: AppTextStyle.bodyMedium,
        prefix: prefix,
        prefixIcon: prefixIcon,
        prefixIconColor: WidgetStateColor.resolveWith((
            Set<WidgetState> states,
            ) {
          final Color color =
          states.contains(WidgetState.error)
              ? Theme.of(context).colorScheme.error
              : states.contains(WidgetState.focused)
              ? AppColors.focusedTextFormFieldOutlinedBorder
              : AppColors.labelTextFormField;
          return color;
        }),
        prefixIconConstraints:
        prefixIconConstraints != null
            ? prefixIconConstraints!
            : BoxConstraints(
          maxWidth: 48,
          maxHeight: 48,
          minWidth: 36,
          minHeight: 24,
        ),
        hintStyle: TextStyle(
          color: AppColors.hintTextFormField,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.enabledTextFormFieldOutlinedBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.enabledTextFormFieldOutlinedBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.focusedTextFormFieldOutlinedBorder,
            width: 1,
          ),
        ),
        suffixIconConstraints: BoxConstraints(maxWidth: 48, maxHeight: 48),
        suffixIcon:
        toggleVisibility ?? false
            ? InkWell(
          onTap: onToggleVisibility,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8,
            ),
            child: Icon(
              obscureText ?? false
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
            ),
          ),
        )
            : null,
      ),
    );
  }
}
