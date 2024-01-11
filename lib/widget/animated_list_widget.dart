import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedListWidget extends StatefulWidget {
  final Widget child;
  final int delay;
  const AnimatedListWidget(
      {super.key, required this.child, required this.delay});

  @override
  State<AnimatedListWidget> createState() => __AnimatedListWidgetState();
}

class __AnimatedListWidgetState extends State<AnimatedListWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    final curve =
        CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _offset =
        Tween(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(curve);
    Timer(Duration(milliseconds: widget.delay), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}
