import 'package:flutter/material.dart';

class CardWithIcon extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final Color? iconBackground;
  final VoidCallback? onTap;

  const CardWithIcon({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.iconBackground,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Card(
        elevation: 0.5,
        shadowColor: Colors.black12.withValues(alpha: 0.05),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Container(
                  decoration: BoxDecoration(
                    color: iconBackground ?? Colors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    icon,
                    color: iconBackground != null
                      ? Colors.white
                      : Colors.blue,
                    size: 18,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                title,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 4),
                Text(
                  description!,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}