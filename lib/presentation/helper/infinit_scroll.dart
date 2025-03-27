import 'package:flutter/material.dart';

mixin InfiniteScrollMixin<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
  }

  void onScroll();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
