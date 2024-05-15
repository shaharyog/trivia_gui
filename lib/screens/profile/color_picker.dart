import 'package:flutter/material.dart';
import '../../consts.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorSave;
  const ColorPickerDialog({
    super.key,
    required this.initialColor,
    required this.onColorSave,
  });
  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}
class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color selectedColor;
  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Avatar Color'),
      content: SizedBox(
        height: 150,
        width: 300,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: avatarColors.length,
          itemBuilder: (BuildContext context, int index) {
            final color = avatarColors[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = color;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MouseRegion(
                    cursor: color == selectedColor ? MouseCursor.defer : SystemMouseCursors.click,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (color == selectedColor)
                    Icon(
                      Icons.check,
                      color: _getContrastColor(color),

                    ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onColorSave(selectedColor);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
Color _getContrastColor(Color color) {
  final brightness = color.computeLuminance();
  return brightness > 0.4 ? Colors.black : Colors.white;
}