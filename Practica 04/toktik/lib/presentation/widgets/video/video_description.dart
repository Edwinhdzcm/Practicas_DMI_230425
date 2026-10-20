import 'package:flutter/material.dart';

/// Título + descripción. Si la descripción pasa de [collapsedLines] líneas
/// se muestra "... más"; al abrirla queda en un área con scroll vertical.
class VideoDescription extends StatefulWidget {
  final String caption;
  final String description;
  final int collapsedLines;
  final double expandedMaxHeight;

  const VideoDescription({
    super.key,
    required this.caption,
    required this.description,
    this.collapsedLines = 2,
    this.expandedMaxHeight = 160,
  }) : assert(collapsedLines > 0, 'collapsedLines debe ser mayor a 0');

  @override
  State<VideoDescription> createState() => _VideoDescriptionState();
}

class _VideoDescriptionState extends State<VideoDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = Theme.of(context).colorScheme.primary;
    final bodyStyle = textTheme.bodyMedium ?? const TextStyle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.caption,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (widget.description.isNotEmpty) ...[
          const SizedBox(height: 4),
          LayoutBuilder(
            builder: (context, constraints) {
              final painter = TextPainter(
                text: TextSpan(text: widget.description, style: bodyStyle),
                maxLines: widget.collapsedLines,
                textDirection: TextDirection.ltr,
              )..layout(maxWidth: constraints.maxWidth);

              final exceeds = painter.didExceedMaxLines;

              // Cabe completa: se muestra tal cual.
              if (!exceeds) {
                return Text(widget.description, style: bodyStyle);
              }

              if (!_expanded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.description,
                      maxLines: widget.collapsedLines,
                      overflow: TextOverflow.clip,
                      style: bodyStyle,
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _expanded = true),
                      child: Text('... más',
                          style: bodyStyle.copyWith(
                              color: accent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                );
              }

              // Expandida: área con desplazamiento vertical
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: widget.expandedMaxHeight),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Text(widget.description, style: bodyStyle),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _expanded = false),
                    child: Text('menos',
                        style: bodyStyle.copyWith(
                            color: accent, fontWeight: FontWeight.bold)),
                  ),
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}
