import 'package:flutter/material.dart';
import '../../core/theme/orbit_radius.dart';

class OrbitSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  const OrbitSearchBar({
    super.key,
    this.hintText = 'Search...',
    required this.onChanged,
    this.controller,
  });

  @override
  State<OrbitSearchBar> createState() => _OrbitSearchBarState();
}

class _OrbitSearchBarState extends State<OrbitSearchBar> {
  late final TextEditingController _controller;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleControllerChange);
  }

  void _handleControllerChange() {
    final showClear = _controller.text.isNotEmpty;
    if (showClear != _showClear) {
      setState(() => _showClear = showClear);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleControllerChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: _showClear
            ? IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: OrbitRadius.brMd,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
