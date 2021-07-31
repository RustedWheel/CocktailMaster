import 'package:cocktail_master/common/cocktail_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cocktail_master/common/spacing.dart';

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({required this.widget});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    var backgroundAlpha = shrinkOffset / 80.0;
    return Container(
      color: CocktailColors.background1.withOpacity(backgroundAlpha),
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: Spacing.spacing1x, horizontal: Spacing.spacing1xhalf),
      child: Center(child: widget)
    );
  }

  @override
  double get maxExtent => 80.0;

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
