import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/constants.dart';

/// Custom form field with enhanced styling and validation
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final int maxLines;
  final int? maxLength;
  final bool isRequired;
  final bool enabled;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final Widget? prefix;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    required this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.maxLength,
    this.isRequired = false,
    this.enabled = true,
    this.onChanged,
    this.validator,
    this.suffix,
    this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with optional required indicator
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8),
          
          // Text field with enhanced styling
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            enabled: enabled,
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: enabled 
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100]
                  : Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[400]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[400]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: suffix,
              prefixIcon: prefix,
            ),
            onChanged: onChanged,
            validator: validator ?? (isRequired 
                ? (value) => value == null || value.trim().isEmpty 
                    ? 'Please enter $label' 
                    : null
                : null),
          ),
        ],
      ),
    );
  }
}

/// Price field with currency formatting
class PriceField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final Function(double)? onChanged;
  final String? Function(String?)? validator;
  final String currencySymbol;

  const PriceField({
    Key? key,
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.onChanged,
    this.validator,
    this.currencySymbol = '\$',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hint: '0.00',
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      isRequired: isRequired,
      prefix: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(
          currencySymbol,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onChanged: (value) {
        if (onChanged != null) {
          final doubleValue = double.tryParse(value) ?? 0.0;
          onChanged!(doubleValue);
        }
      },
      validator: validator ?? (isRequired
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter $label';
              }
              final doubleValue = double.tryParse(value);
              if (doubleValue == null) {
                return 'Please enter a valid number';
              }
              if (doubleValue < 0) {
                return 'Price cannot be negative';
              }
              return null;
            }
          : null),
    );
  }
}

/// Toggle switch with custom styling
class CustomSwitchFormField extends StatelessWidget {
  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;

  const CustomSwitchFormField({
    Key? key,
    required this.label,
    this.description,
    required this.value,
    required this.onChanged,
    this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Switch
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: activeColor ?? theme.colorScheme.primary,
              ),
              SizedBox(width: 8),
              
              // Label and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (description != null) ...[
                      SizedBox(height: 4),
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom chips input for tags, allergens, etc.
class ChipsInputField extends StatefulWidget {
  final String label;
  final List<String> values;
  final ValueChanged<List<String>> onChanged;
  final String? hint;
  final bool isRequired;

  const ChipsInputField({
    Key? key,
    required this.label,
    required this.values,
    required this.onChanged,
    this.hint,
    this.isRequired = false,
  }) : super(key: key);

  @override
  _ChipsInputFieldState createState() => _ChipsInputFieldState();
}

class _ChipsInputFieldState extends State<ChipsInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addItem(String text) {
    if (text.trim().isEmpty) return;
    
    final newValues = List<String>.from(widget.values);
    if (!newValues.contains(text.trim())) {
      newValues.add(text.trim());
      widget.onChanged(newValues);
    }
    _controller.clear();
  }

  void _removeItem(int index) {
    final newValues = List<String>.from(widget.values);
    newValues.removeAt(index);
    widget.onChanged(newValues);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 8),
          
          // Chips display
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Existing chips
              ...List.generate(
                widget.values.length,
                (index) => Chip(
                  label: Text(widget.values[index]),
                  deleteIcon: Icon(Icons.close, size: 18),
                  onDeleted: () => _removeItem(index),
                ),
              ),
              
              // Input chip
              InputChip(
                label: Container(
                  width: 100,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hint ?? 'Add ${widget.label.toLowerCase()}',
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (value) {
                      _addItem(value);
                      _focusNode.requestFocus();
                    },
                  ),
                ),
                onPressed: () {
                  _focusNode.requestFocus();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}