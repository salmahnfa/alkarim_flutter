import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'theme/app_colors.dart';

class JilidList extends StatelessWidget {
  final String title;
  final String description;
  final int halaman;
  final VoidCallback? onTap;

  const JilidList({
    super.key,
    required this.title,
    required this.description,
    required this.halaman,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600, color: AppColors.textPrimary
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: (Theme.of(context).textTheme.bodyMedium!.fontSize ?? 14) * 2.8,
                    child: Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.6),
                        child: Icon(CupertinoIcons.book_fill, color: Colors.white, size: 12)
                      ),
                      SizedBox(width: 8),
                      Text(
                        '$halaman halaman',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}